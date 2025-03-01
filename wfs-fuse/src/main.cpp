#define FUSE_USE_VERSION 31

#include <assert.h>
#include <errno.h>
#include <fcntl.h>
#include <fuse.h>
#include <stddef.h>
#include <stdio.h>
#include <string.h>
#include <wfslib/wfslib.h>
#include <mutex>
#include <string>

static std::shared_ptr<WfsDevice> g_wfs_device;

struct locked_stream {
  std::unique_ptr<File::stream> stream;
  std::mutex lock;
};

static int wfs_getattr(const char* path, struct stat* stbuf) {
  memset(stbuf, 0, sizeof(struct stat));

  auto entry = g_wfs_device->GetEntry(path);
  if (!entry)
    return -ENOENT;
  if (entry->is_directory()) {
    stbuf->st_mode = S_IFDIR | 0755;
    stbuf->st_nlink = 2 + std::dynamic_pointer_cast<Directory>(entry)->size();
  } else if (entry->is_link()) {
    stbuf->st_mode = S_IFLNK | 0777;
    stbuf->st_nlink = 1;
    stbuf->st_size = 0;  // TODO
  } else if (entry->is_file()) {
    stbuf->st_mode = S_IFREG | 0444;
    stbuf->st_nlink = 1;
    stbuf->st_size = std::dynamic_pointer_cast<File>(entry)->Size();
  } else {
    // Should not happen
    return -ENOENT;
  }

  return 0;
}

static int wfs_readdir(const char* path, void* buf, fuse_fill_dir_t filler, off_t offset, struct fuse_file_info* fi) {
  (void)offset;
  (void)fi;

  auto entry = g_wfs_device->GetEntry(path);
  if (!entry || !entry->is_directory())
    return -ENOENT;

  filler(buf, ".", NULL, 0);
  filler(buf, "..", NULL, 0);

  for (auto [name, subentry] : *std::dynamic_pointer_cast<Directory>(entry)) {
    filler(buf, name.c_str(), NULL, 0);
  }

  return 0;
}

static int wfs_open(const char* path, struct fuse_file_info* fi) {
  auto entry = g_wfs_device->GetEntry(path);
  if (!entry->is_file())
    return -ENOENT;

  if ((fi->flags & O_ACCMODE) != O_RDONLY)
    return -EACCES;

  fi->fh = reinterpret_cast<uint64_t>(
      new locked_stream{std::unique_ptr<File::stream>(new File::stream(std::dynamic_pointer_cast<File>(entry))), {}});

  return 0;
}

static int wfs_release(const char* path, struct fuse_file_info* fi) {
  (void)path;

  delete reinterpret_cast<locked_stream*>(fi->fh);
  return 0;
}

static int wfs_read(const char* path, char* buf, size_t size, off_t offset, struct fuse_file_info* fi) {
  (void)path;

  auto stream = reinterpret_cast<locked_stream*>(fi->fh);
  std::lock_guard<std::mutex> guard(stream->lock);

  stream->stream->seekg(offset, stream->stream->beg);
  stream->stream->read(buf, size);

  return static_cast<int>(stream->stream->gcount());
}

int wfs_readlink(const char* path, [[maybe_unused]] char* buf, [[maybe_unused]] size_t size) {
  // TODO
  auto entry = g_wfs_device->GetEntry(path);
  if (!entry || !entry->is_link())
    return -ENOENT;

  // TODO
  return -ENOENT;
}

static const char* usage =
    "usage: wfs-fuse <device_file> <mountpoint> [--type <file type>] [--otp <otp_path> [--seeprom <seeprom_path>]] "
    "[fuse options]\n"
    "\n"
    "options:\n"
    "    --help|-h              print this help message\n"
    "    --type [usb/mlc/plain] type of device\n"
    "    --otp <path>           otp file (for mlc and usb modes)\n"
    "    --seeprom <path>       seeprom file (for usb mode)\n"
    "    -d   -o debug          enable debug output (implies -f)\n"
    "    -o default_permissions check access permission instead the operation system\n"
    "    -o allow_other         allow access to the mount for all users\n"
    "    -f                     foreground operation\n"
    "    -s                     disable multi-threaded operation\n"
    "\n";

struct wfs_param {
  char* file;
  char* type;
  char* otp;
  char* seeprom;
  int is_help;
};

#define WFS_OPT(t, p) \
  { t, offsetof(struct wfs_param, p), 1 }

static const struct fuse_opt wfs_opts[] = {WFS_OPT("--type %s", type),       WFS_OPT("--otp %s", otp),
                                           WFS_OPT("--seeprom %s", seeprom), FUSE_OPT_KEY("-h", 0),
                                           FUSE_OPT_KEY("--help", 0),        FUSE_OPT_END};

static int wfs_process_arg(void* data, const char* arg, int key, struct fuse_args* outargs) {
  struct wfs_param* param = static_cast<wfs_param*>(data);

  (void)outargs;
  (void)arg;

  switch (key) {
    case 0:
      param->is_help = 1;
      fprintf(stderr, "%s", usage);
      return fuse_opt_add_arg(outargs, "-ho");

    case FUSE_OPT_KEY_NONOPT:
      if (!param->file) {
        param->file = strdup(arg);
        return 0;
      }
      return 1;
    default:
      return 1;
  }
}

std::optional<std::vector<std::byte>> get_key(std::string type,
                                              std::optional<std::string> otp_path,
                                              std::optional<std::string> seeprom_path) {
  if (type == "mlc") {
    if (!otp_path)
      throw std::runtime_error("missing otp");
    std::unique_ptr<OTP> otp(OTP::LoadFromFile(*otp_path));
    return otp->GetMLCKey();
  } else if (type == "usb") {
    if (!otp_path || !seeprom_path)
      throw std::runtime_error("missing seeprom");
    std::unique_ptr<OTP> otp(OTP::LoadFromFile(*otp_path));
    std::unique_ptr<SEEPROM> seeprom(SEEPROM::LoadFromFile(*seeprom_path));
    return seeprom->GetUSBKey(*otp);
  } else if (type == "plain") {
    return std::nullopt;
  } else {
    throw std::runtime_error("unexpected type");
  }
}

int main(int argc, char* argv[]) {
  struct fuse_args args = FUSE_ARGS_INIT(argc, argv);
  struct wfs_param param = {NULL, NULL, NULL, NULL, 0};
  std::string type;
  bool is_usb, is_mlc, is_plain;
  std::optional<std::string> otp_path, seeprom_path;

  if (argc < 3) {
    fprintf(stderr, "%s", usage);
    return 1;
  }
  if (fuse_opt_parse(&args, &param, wfs_opts, wfs_process_arg)) {
    fprintf(stderr, "failed to parse option\n");
    return 1;
  }

  if (param.is_help) {
    return 0;
  }

  type = param.type ? param.type : "usb";
  is_usb = type == "usb";
  is_mlc = type == "mlc";
  is_plain = type == "plain";
  if (!is_usb && !is_mlc && !is_plain) {
    fprintf(stderr, "Unsupported type (--type=usb/mlc/plain)\n");
    return 1;
  }
  if ((is_mlc || is_usb) && !param.otp) {
    fprintf(stderr, "Missing otp file (--otp)\n");
    return 1;
  }
  if (is_usb && !param.seeprom) {
    fprintf(stderr, "Missing seeprom file (--seeprom)\n");
    return 1;
  }
  if (param.otp)
    otp_path = param.otp;
  if (param.seeprom)
    seeprom_path = param.seeprom;

  try {
    auto key = get_key(type, otp_path, seeprom_path);
    auto device = std::make_shared<FileDevice>(param.file, 9);
    auto detection_result = Recovery::DetectDeviceParams(device, key);
    if (detection_result.has_value()) {
      if (*detection_result == WfsError::kInvalidWfsVersion)
        fprintf(stderr, "Error: Incorrect WFS version, possible wrong keys\n");
      else
        fprintf(stderr, "Error: %s\n", WfsException(*detection_result).what());
      return 1;
    }
    auto wfs_device = WfsDevice::Open(device, key);
    if (!wfs_device.has_value()) {
      fprintf(stderr, "Error: %s\n", WfsException(wfs_device.error()).what());
      return 1;
    }
    g_wfs_device = std::move(*wfs_device);
  } catch (std::exception& e) {
    fprintf(stderr, "Error: %s\n", e.what());
    return 1;
  }

  struct fuse_operations wfs_oper = {};
  wfs_oper.getattr = wfs_getattr;
  wfs_oper.readdir = wfs_readdir;
  wfs_oper.open = wfs_open;
  wfs_oper.release = wfs_release;
  wfs_oper.read = wfs_read;
  wfs_oper.readlink = wfs_readlink;

  return fuse_main(args.argc, args.argv, &wfs_oper, NULL);
}
