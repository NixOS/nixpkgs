/* the nixos-jobserver FUSE filesystem.
 *
 * provides a single file (the token file) from which a client can pull tokens
 * out of a global pool, and to which clients return tokens when they are done
 * with them. if a client exits without returning all tokens they are returned
 * to the global pool. the token file is compatible with the GNU Make jobserver
 * protocol.
 *
 * the original make jobserver uses simple pipes for token storage and transfer.
 * this works fine for make, where one job does not substantially outlive its first
 * failing component. it is not suitable for global jobservers, since a job may
 * have failed without being able to return its tokens (eg because it was killed
 * by SIGKILL, as nix-daemon does). we thus have to track how many tokens a client
 * has acquired and return them if the client goes away, but to do this we also
 * need to know when a client dies. this can be done with FUSE as done here, but
 * could also be achieved with simple pipes or unix domain sockets. neither of
 * these are a good choice for this problem:
 *
 * pipes are a resource shared between all processes that have opened said pipe.
 * to be useful for a global jobserver we'd have to provide a unique pipe for
 * each client, which requires more invasive changes to a nix configuration than
 * using FUSE.
 *
 * both pipes and sockets have buffers. it is not possible to poll a pipe or
 * socket for "the other end wants to read a byte", it is only possible to poll
 * for available buffer space. distributing tokens among multiple clients of the
 * jobserver must then be done by partitioning the available tokens and giving
 * one partition to each client and periodically rebalancing according to actual
 * usage. this periodic process necessarily causes more overhead than using the
 * kernel as a notification source for "the other end wants to read a byte" and
 * introduces unnecessary latency into token transfers between jobs.
 */

#define FUSE_USE_VERSION 35

#include <errno.h>
#include <fuse.h>
#include <fuse_lowlevel.h>
#include <grp.h>
#include <poll.h>
#include <pwd.h>
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <sys/sysinfo.h>
#include <sys/xattr.h>
#include <unistd.h>

#include <algorithm>
#include <atomic>
#include <iostream>
#include <limits>
#include <list>
#include <memory>
#include <optional>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>

// 0x0A is ^J :)
#define JOBSRV_IOC_SET_LIMIT _IOW(0x0A, 0, unsigned)

struct PollHandleDestroy {
    void operator()(fuse_pollhandle* ph) { fuse_pollhandle_destroy(ph); }
};

using PollHandle = std::unique_ptr<fuse_pollhandle, PollHandleDestroy>;

struct Context {
    unsigned tokens_held{0};
    unsigned limit{std::numeric_limits<unsigned>::max()};
    PollHandle poll;
};

struct stat jobserver_st = {
    .st_ino = FUSE_ROOT_ID,
    .st_mode = S_IFREG | 0660,
    .st_uid = getuid(),
    .st_gid = getgid(),
};
static const std::string acl_name = "system.posix_acl_access";
static std::optional<std::vector<char>> acl;

static unsigned tokens = 0;
static std::unordered_set<Context*> poll_waiters;
static std::unordered_map<fuse_req_t, Context*> read_waiters;

static void wake_waiters()
{
    for (auto it = read_waiters.begin(); it != read_waiters.end() && tokens > 0; ) {
        auto& ctx = *it->second;

        if (ctx.tokens_held >= ctx.limit) {
            it++;
            continue;
        }

        fuse_reply_buf(it->first, "+", 1);
        ctx.tokens_held++;
        tokens--;
        read_waiters.erase(it++);
    }

    if (tokens > 0) {
        for (auto it = poll_waiters.begin(); it != poll_waiters.end(); ) {
            auto waiter = *it;

            if (waiter->tokens_held >= waiter->limit) {
                it++;
                continue;
            }

            fuse_lowlevel_notify_poll(waiter->poll.get());
            poll_waiters.erase(it++);
        }
    }
}

static void interrupt_func(fuse_req_t req, void* data)
{
    fuse_reply_err(req, EINTR);
    read_waiters.erase(req);
}

static Context* fi_ctx(fuse_file_info* fi)
{
    static_assert(sizeof(fi->fh) >= sizeof(Context*));
    return reinterpret_cast<Context*>(fi->fh);
}

static void jobserver_getattr(fuse_req_t req, fuse_ino_t ino, fuse_file_info* fi)
{
    // long attribute cache times are preferrable for purely local systems like this.
    // this also affects xattr caching, which in turn affects acl caching.
    fuse_reply_attr(req, &jobserver_st, 120);
}

static void jobserver_setattr(fuse_req_t req, fuse_ino_t ino, struct stat* attr, int to_set, fuse_file_info* fi)
{
    if ((to_set & ~(FUSE_SET_ATTR_MODE | FUSE_SET_ATTR_UID | FUSE_SET_ATTR_GID))
            || !S_ISREG(attr->st_mode)) {
        fuse_reply_err(req, EINVAL);
        return;
    }

    if (to_set & FUSE_SET_ATTR_MODE) {
        jobserver_st.st_mode = attr->st_mode;
    }
    if (to_set & FUSE_SET_ATTR_UID) {
        jobserver_st.st_uid = attr->st_uid;
    }
    if (to_set & FUSE_SET_ATTR_GID) {
        jobserver_st.st_gid = attr->st_gid;
    }

    fuse_reply_attr(req, &jobserver_st, 120);
}

static void jobserver_open(fuse_req_t req, fuse_ino_t ino, fuse_file_info* fi)
{
    auto ctx = new Context;
    static_assert(sizeof(fi->fh) >= sizeof(ctx));
    fi->fh = reinterpret_cast<uint64_t>(ctx);
    fi->direct_io = 1;
    fuse_reply_open(req, fi);
}

static void jobserver_release(fuse_req_t req, fuse_ino_t ino, fuse_file_info* fi)
{
    auto ctx = fi_ctx(fi);
    poll_waiters.erase(ctx);
    tokens += ctx->tokens_held;
    delete ctx;
    fuse_reply_err(req, 0);
    wake_waiters();
}

static void jobserver_read(fuse_req_t req, fuse_ino_t ino, size_t size, off_t off, fuse_file_info* fi)
{
    if (size == 0) {
        fuse_reply_buf(req, "", 0);
        return;
    }

    auto& ctx = *fi_ctx(fi);

    if (tokens > 0 && ctx.tokens_held < ctx.limit) {
        tokens--;
        ctx.tokens_held++;
        fuse_reply_buf(req, "+", 1);
    } else if (fi->flags & O_NONBLOCK) {
        fuse_reply_err(req, EAGAIN);
    } else {
        read_waiters.emplace(req, &ctx);
        // if we're already interrupted the emplace will be undone
        fuse_req_interrupt_func(req, interrupt_func, nullptr);
    }
}

static void jobserver_write(fuse_req_t req, fuse_ino_t ino, const char* buf, size_t size, off_t off,
        fuse_file_info* fi)
{
    auto& ctx = *fi_ctx(fi);

    size = std::min<size_t>(size, ctx.tokens_held);
    tokens += size;
    ctx.tokens_held -= size;
    fuse_reply_write(req, size);
    wake_waiters();
}

static void jobserver_setxattr(fuse_req_t req, fuse_ino_t ino, const char* name, const char* value,
        size_t size, int flags)
{
    if (name != acl_name) {
        fuse_reply_err(req, EINVAL);
    } else if ((flags & XATTR_CREATE) && acl) {
        fuse_reply_err(req, EEXIST);
    } else if ((flags & XATTR_REPLACE) && !acl) {
        fuse_reply_err(req, ENODATA);
    } else {
        // we need to update file permission bits according to the new acl.
        // parsing an acl is not pretty and setting this acl should be rare, so we'll just
        // be incredibly lazy about it and let the kernel do the heavy lifting.
        int mfd = memfd_create("acl_tmp", 0);
        std::unique_ptr<int, void(*)(int*)> const _mfd(&mfd, [] (int* fd) { close(*fd); });
        struct stat tmp;

        if (fsetxattr(mfd, name, value, size, 0) == 0
                && fstat(mfd, &tmp) == 0) {
            jobserver_st.st_mode = S_IFREG | (tmp.st_mode & 07777);
            acl.emplace(value, value + size);
            fuse_reply_err(req, 0);
        } else {
            fuse_reply_err(req, errno);
        }
    }
}

static void jobserver_getxattr(fuse_req_t req, fuse_ino_t ino, const char* name, size_t size)
{
    if (name != acl_name) {
        fuse_reply_err(req, EINVAL);
    } else if (!acl) {
        fuse_reply_err(req, ENODATA);
    } else if (size == 0) {
        fuse_reply_xattr(req, acl->size());
    } else if (size < acl->size()) {
        fuse_reply_err(req, ERANGE);
    } else {
        fuse_reply_buf(req, acl->data(), acl->size());
    }
}

static void jobserver_listxattr(fuse_req_t req, fuse_ino_t ino, size_t size)
{
    if (size == 0) {
        fuse_reply_xattr(req, acl_name.size() + 1);
    } else if (size < acl_name.size() + 1) {
        fuse_reply_err(req, ERANGE);
    } else {
        fuse_reply_buf(req, acl_name.c_str(), acl_name.size() + 1);
    }
}

static void jobserver_removexattr(fuse_req_t req, fuse_ino_t ino, const char* name)
{
    if (name != acl_name) {
        fuse_reply_err(req, EINVAL);
    } else if (acl) {
        acl.reset();
        fuse_reply_err(req, 0);
    } else {
        fuse_reply_err(req, ENODATA);
    }
}

static void jobserver_ioctl(fuse_req_t req, fuse_ino_t ino, unsigned int cmd, void* arg,
        fuse_file_info* fi, unsigned flags, const void* in_buf, size_t in_bufsz, size_t out_bufsz)
{
    auto& ctx = *fi_ctx(fi);

    if (flags & FUSE_IOCTL_COMPAT) {
        fuse_reply_err(req, ENOSYS);
        return;
    }

    switch (cmd) {
    case JOBSRV_IOC_SET_LIMIT:
        ctx.limit = *reinterpret_cast<const unsigned*>(in_buf);
        if (ctx.limit == 0) {
            ctx.limit = std::numeric_limits<unsigned>::max();
        }
        fuse_reply_ioctl(req, 0, nullptr, 0);
        break;

    default:
        fuse_reply_err(req, ENOTTY);
    }
}

static void jobserver_poll(fuse_req_t req, fuse_ino_t ino, fuse_file_info* fi, fuse_pollhandle* ph)
{
    auto& ctx = *fi_ctx(fi);

    ctx.poll.reset(ph);
    if (ph) {
        poll_waiters.insert(&ctx);
    }
    const auto avail = tokens > 0 && ctx.tokens_held < ctx.limit;
    fuse_reply_poll(req, ((avail ? POLLIN : 0) | POLLOUT) & fi->poll_events);
}

static const struct fuse_lowlevel_ops jobserver_ops = {
    .init = [] (void* userdata, fuse_conn_info* conn) {
        conn->want = FUSE_CAP_POSIX_ACL;
    },
    .getattr = jobserver_getattr,
    .setattr = jobserver_setattr,
    .open = jobserver_open,
    .read = jobserver_read,
    .write = jobserver_write,
    .release = jobserver_release,
    .setxattr = jobserver_setxattr,
    .getxattr = jobserver_getxattr,
    .listxattr = jobserver_listxattr,
    .removexattr = jobserver_removexattr,
    .ioctl = jobserver_ioctl,
    .poll = jobserver_poll,
};

static void print_help(std::ostream& to)
{
    to << R"(usage: nixos-jobserver -t <tokens> <mount point>

starts a job server with the given number of tokens at the specified mount
point. must be started as root to allow other users access to the jobserver.

arguments:

  -h           print help text
  -t <tokens>  set number of tokens available (uses number of CPUs when 0)
  -u <user>    mount jobserver with owner <user>
  -g <group>   mount jobserver with group <group>
  -d           debug mode (log fuse requests)
)";
}

int main(int argc, char* argv[])
{
    std::string mount, user, group;
    std::vector<std::string> args{
        argv[0],
        "-odefault_permissions",
    };

    if (geteuid() == 0) {
        args.push_back("-oallow_other");
    }

    for (;;) {
        int opt = getopt(argc, argv, "hdu:g:t:");
        if (opt == -1)
            break;
        switch (opt) {
        case 'd':
            args.push_back("-d");
            break;
        case 'u':
            user = optarg;
            break;
        case 'g':
            group = optarg;
            break;
        case 't': {
            char* end;
            auto res = strtoul(optarg, &end, 10);
            if (errno || isspace(optarg[0]) || *end || res > std::numeric_limits<unsigned>::max()) {
                std::cerr << "bad argument for -t" << std::endl;
                return 1;
            }
            tokens = res;
            break;
        }
        case 'h':
            print_help(std::cout);
            return 0;
        default:
            print_help(std::cerr);
            return 1;
        }
    }

    if (optind >= argc) {
        std::cerr << "missing mount point" << std::endl;
        return 1;
    } else if (optind + 1 < argc) {
        std::cerr << "extraneous arguments after mount point" << std::endl;
        return 1;
    } else {
        mount = argv[optind];
    }

    if (tokens == 0) {
        tokens = get_nprocs_conf();
    }

    if (!user.empty()) {
        if (auto pw = getpwnam(user.c_str()); pw) {
            jobserver_st.st_uid = pw->pw_uid;
        } else if (uid_t uid; sscanf(user.c_str(), "%u%c", &uid, (char*) &uid) == 1) {
            jobserver_st.st_uid = uid;
        } else {
            std::cerr << "invalid argument for -u" << std::endl;
            return 1;
        }
    }

    if (!group.empty()) {
        if (auto gr = getgrnam(group.c_str()); gr) {
            jobserver_st.st_gid = gr->gr_gid;
        } else if (gid_t gid; sscanf(group.c_str(), "%u%c", &gid, (char*) &gid) == 1) {
            jobserver_st.st_gid = gid;
        } else {
            std::cerr << "invalid argument for -g" << std::endl;
            return 1;
        }
    }

    using Session = std::unique_ptr<fuse_session, void(*)(fuse_session*)>;

    std::vector<char*> args_ptrs(args.size());
    std::transform(args.begin(), args.end(), args_ptrs.begin(),
            [] (auto& str) { return &str[0]; });
    fuse_args fuse_args = FUSE_ARGS_INIT(int(args_ptrs.size()), args_ptrs.data());

    Session se{
        fuse_session_new(&fuse_args, &jobserver_ops, sizeof(jobserver_ops), nullptr),
        fuse_session_destroy
    };
    if (!se) {
        std::cerr << "fuse_session failed" << std::endl;
        return 1;
    }

    if (fuse_set_signal_handlers(&*se) != 0) {
        std::cerr << "fuse_set_signal_handlers failed" << std::endl;
        return 1;
    }
    const Session _signals{&*se, fuse_remove_signal_handlers};

    if (fuse_session_mount(&*se, mount.c_str()) != 0) {
        std::cerr << "fuse_session_mount failed" << std::endl;
        return 1;
    }
    const Session _unmount{&*se, fuse_session_unmount};

    return fuse_session_loop(&*se) ? 2 : 0;
}
