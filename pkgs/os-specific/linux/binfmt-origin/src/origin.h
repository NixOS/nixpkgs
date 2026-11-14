/* SPDX-License-Identifier: GPL-2.0 */
/*
 * Shared pieces of the elf_origin and script_origin binfmt_misc_ops
 * handlers: the kfunc declarations, the per-exec scratch map and the
 * "$ORIGIN/..." to absolute path resolution.
 *
 * Both handlers resolve "$ORIGIN" to the directory that holds the file
 * being executed, as reported by d_path() on bprm->file. Symlinks are
 * therefore already resolved, matching the way ld.so expands $ORIGIN.
 */
#ifndef BINFMT_ORIGIN_H
#define BINFMT_ORIGIN_H

#include "vmlinux.h"
#include <bpf/bpf_helpers.h>
#include <bpf/bpf_tracing.h>

#define PATH_MAX		4096
#define BINPRM_BUF_SIZE		256

#define ORIGIN			"$ORIGIN"
#define ORIGIN_LEN		(sizeof(ORIGIN) - 1)
/* "$ORIGIN/" plus at least one character and the NUL. */
#define ORIGIN_MIN_SIZE		(ORIGIN_LEN + 3)

#define ENOENT			2
#define ENOEXEC			8
#define ENAMETOOLONG		36

/* The most program headers either handler walks before giving up. */
#define MAX_PHDRS		64

/* Upper bound on concurrent execs going through one handler. */
#define MAX_INFLIGHT_EXECS	512

extern int bpf_dynptr_from_file(struct file *file, __u32 flags,
				struct bpf_dynptr *ptr__uninit) __ksym;
extern int bpf_dynptr_file_discard(struct bpf_dynptr *dynptr) __ksym;
extern int bpf_path_d_path(const struct path *path, char *buf,
			   size_t buf__sz) __ksym;
extern int bpf_binprm_set_interp(struct linux_binprm *bprm, const char *path,
				 size_t path__sz) __ksym;
extern int bpf_binprm_set_interp_arg(struct linux_binprm *bprm,
				     const char *arg, size_t arg__sz) __ksym;
extern int bpf_binprm_set_flags(struct linux_binprm *bprm,
				enum bpf_binprm_flags flags) __ksym;

/*
 * Per-exec working memory. The buffers are far larger than the 512 byte
 * bpf stack, so they live in a hash map value keyed by pid_tgid: execs run
 * concurrently and both programs can sleep.
 */
struct scratch {
	char line[BINPRM_BUF_SIZE];	/* copy of bprm->buf (script handler) */
	char interp[PATH_MAX];		/* "$ORIGIN/..." as found in the file */
	char arg[BINPRM_BUF_SIZE];	/* optional shebang argument */
	char path[PATH_MAX];		/* d_path of the file, then the result */
};

struct {
	__uint(type, BPF_MAP_TYPE_HASH);
	__uint(max_entries, MAX_INFLIGHT_EXECS);
	__type(key, __u64);
	__type(value, struct scratch);
} scratch_map SEC(".maps");

static const struct scratch zero_scratch;

/* Claim a zeroed scratch slot for the current task, or NULL. */
static __always_inline struct scratch *scratch_get(__u64 id)
{
	if (bpf_map_update_elem(&scratch_map, &id, &zero_scratch, BPF_ANY)) {
		return NULL;
	}

	return bpf_map_lookup_elem(&scratch_map, &id);
}

/* Does @s (at least ORIGIN_LEN + 1 bytes) start with "$ORIGIN/"? */
static __always_inline bool has_origin_prefix(const char *s)
{
	return s[0] == '$' && s[1] == 'O' && s[2] == 'R' && s[3] == 'I' &&
	       s[4] == 'G' && s[5] == 'I' && s[6] == 'N' && s[7] == '/';
}

/*
 * Resolve sc->interp, which holds "$ORIGIN/<suffix>" and is NUL-terminated
 * at @isz - 1, against the directory of the file being executed. The
 * absolute result is left NUL-terminated in sc->path.
 *
 * Return: the size of the result including its NUL, or a negative errno.
 */
static __always_inline int origin_resolve(struct linux_binprm *bprm,
					  struct scratch *sc, __u32 isz)
{
	__u32 slash = 0, sfx, rsz;
	int len, i;

	/* Fetch the absolute path of the file being executed. */
	len = bpf_path_d_path(&bprm->file->f_path, sc->path, sizeof(sc->path));
	if (len <= 0 || len > sizeof(sc->path)) {
		return -ENOENT;
	}

	/* Unreachable or unlinked ("... (deleted)") files cannot resolve. */
	if (sc->path[0] != '/') {
		return -ENOENT;
	}

	/* $ORIGIN is everything before the last '/' of that path. */
	bpf_for(i, 1, len - 1) {
		if (i >= sizeof(sc->path)) {
			break;
		}
		if (sc->path[i] == '/') {
			slash = i;
		}
	}

	/* Splice the suffix (leading '/' and NUL included) onto the dir. */
	sfx = isz - ORIGIN_LEN;
	rsz = slash + sfx;
	if (rsz > sizeof(sc->path)) {
		return -ENAMETOOLONG;
	}
	bpf_for(i, 0, sfx) {
		__u32 s = ORIGIN_LEN + i, d = slash + i;

		if (s >= sizeof(sc->interp) || d >= sizeof(sc->path)) {
			break;
		}
		sc->path[d] = sc->interp[s];
	}

	return rsz;
}

#endif /* BINFMT_ORIGIN_H */
