// SPDX-License-Identifier: GPL-2.0
/*
 * script_origin.bpf.c - $ORIGIN-relative #! interpreters for binfmt_misc
 *
 * A binfmt_misc_ops handler for relocatable scripts. The interpreter of
 * such a script is named relative to the directory holding the script,
 * in one of two places:
 *
 *  - Line 1 is "#!$ORIGIN/<path> [arg]". The script only runs with this
 *    handler loaded.
 *
 *  - Line 1 is an ordinary absolute "#!" line and line 2 carries the
 *    relocatable one, optionally behind a single comment-leader token:
 *
 *      #!/nix/store/...-bash-5.3/bin/bash -e
 *      #!$ORIGIN/../../...-bash-5.3/bin/bash -e
 *
 *      #!/nix/store/...-lua-5.5/bin/lua
 *      -- #!$ORIGIN/../../...-lua-5.5/bin/lua
 *
 *    Kernels without this handler run line 1 and every interpreter reads
 *    line 2 as a comment, so the script stays backwards compatible. This
 *    mirrors the second-line "#! nix-shell" convention.
 *
 * Both lines have to fit in the 256 bytes the kernel prefetches into
 * bprm->buf; a script whose relocatable line is cut off there is declined
 * and runs through binfmt_script as usual. As with binfmt_script, the
 * interpreter ends at the first blank and the rest of the line, trimmed,
 * is passed as a single argument.
 */
#include "origin.h"

char _license[] SEC("license") = "GPL";

/* Signals that a parse step found nothing; never a valid offset. */
#define NOT_FOUND	BINPRM_BUF_SIZE

static __always_inline bool is_blank(char c)
{
	return c == ' ' || c == '\t';
}

static __always_inline bool is_line_end(char c)
{
	return c == '\n' || c == '\0';
}

/*
 * Copy bprm->buf into the scratch map value. bprm->buf can only be read at
 * constant offsets, and the parser below indexes it with variables.
 */
static __always_inline void copy_header(struct linux_binprm *bprm,
					struct scratch *sc)
{
	int i;

#pragma clang loop unroll(full)
	for (i = 0; i < BINPRM_BUF_SIZE; i++) {
		sc->line[i] = bprm->buf[i];
	}
}

/* Offset of the first non-blank character at or after @p. */
static __always_inline __u32 skip_blanks(struct scratch *sc, __u32 p)
{
	int i;

	bpf_for(i, 0, BINPRM_BUF_SIZE) {
		__u32 s = p + i;

		if (s >= BINPRM_BUF_SIZE) {
			return NOT_FOUND;
		}
		if (!is_blank(sc->line[s])) {
			return s;
		}
	}

	return NOT_FOUND;
}

/* Offset of the first blank or line end at or after @p. */
static __always_inline __u32 skip_token(struct scratch *sc, __u32 p)
{
	int i;

	bpf_for(i, 0, BINPRM_BUF_SIZE) {
		__u32 s = p + i;
		char c;

		if (s >= BINPRM_BUF_SIZE) {
			return NOT_FOUND;
		}
		c = sc->line[s];
		if (is_blank(c) || is_line_end(c)) {
			return s;
		}
	}

	return NOT_FOUND;
}

/* Offset just past the '\n' ending the line that contains @p. */
static __always_inline __u32 next_line(struct scratch *sc, __u32 p)
{
	int i;

	bpf_for(i, 0, BINPRM_BUF_SIZE) {
		__u32 s = p + i;
		char c;

		if (s >= BINPRM_BUF_SIZE) {
			return NOT_FOUND;
		}
		c = sc->line[s];
		if (c == '\0') {
			return NOT_FOUND;
		}
		if (c == '\n') {
			return s + 1;
		}
	}

	return NOT_FOUND;
}

/*
 * If @p points at "#!", optionally followed by blanks, and then at
 * "$ORIGIN/", return the offset of the '$'.
 */
static __always_inline __u32 origin_shebang_at(struct scratch *sc, __u32 p)
{
	if (p >= BINPRM_BUF_SIZE - 1) {
		return NOT_FOUND;
	}
	if (sc->line[p] != '#' || sc->line[p + 1] != '!') {
		return NOT_FOUND;
	}

	p = skip_blanks(sc, p + 2);
	if (p > BINPRM_BUF_SIZE - ORIGIN_MIN_SIZE) {
		return NOT_FOUND;
	}
	if (!has_origin_prefix(&sc->line[p])) {
		return NOT_FOUND;
	}

	return p;
}

/* Offset of the relocatable interpreter in either supported form. */
static __always_inline __u32 find_origin_interp(struct scratch *sc)
{
	__u32 p, line2;

	/* Form 1: line 1 is "#!$ORIGIN/...". */
	p = origin_shebang_at(sc, 0);
	if (p != NOT_FOUND) {
		return p;
	}

	/* Form 2 requires an ordinary "#!" on line 1 ... */
	if (sc->line[0] != '#' || sc->line[1] != '!') {
		return NOT_FOUND;
	}
	line2 = next_line(sc, 0);
	if (line2 == NOT_FOUND) {
		return NOT_FOUND;
	}

	/* ... and "#!$ORIGIN/..." on line 2, which is a '#' comment itself, */
	line2 = skip_blanks(sc, line2);
	p = origin_shebang_at(sc, line2);
	if (p != NOT_FOUND) {
		return p;
	}

	/* ... or the same behind one comment-leader token such as "--". */
	p = skip_token(sc, line2);
	if (p == NOT_FOUND) {
		return NOT_FOUND;
	}
	p = skip_blanks(sc, p);

	return origin_shebang_at(sc, p);
}

/*
 * Parse the relocatable "#!" line into sc->interp and sc->arg.
 *
 * Return: the size of sc->interp including its NUL, or a negative errno.
 */
static __always_inline int parse_origin_shebang(struct scratch *sc)
{
	__u32 start, end = NOT_FOUND, ilen = 0, alen = 0, p;
	int i;

	start = find_origin_interp(sc);
	if (start == NOT_FOUND) {
		return -ENOEXEC;
	}

	/* The interpreter runs up to the first blank or line end. */
	bpf_for(i, 0, BINPRM_BUF_SIZE) {
		__u32 s = start + i;
		char c;

		if (s >= BINPRM_BUF_SIZE) {
			return -ENOEXEC;
		}
		c = sc->line[s];
		if (is_blank(c) || is_line_end(c)) {
			end = s;
			break;
		}
		sc->interp[i & (BINPRM_BUF_SIZE - 1)] = c;
		ilen = i + 1;
	}
	if (end == NOT_FOUND || ilen < ORIGIN_MIN_SIZE - 1) {
		return -ENOEXEC;
	}

	/* The rest of the line, minus leading blanks, is the argument. */
	p = skip_blanks(sc, end);
	if (p == NOT_FOUND) {
		return -ENOEXEC;
	}
	bpf_for(i, 0, BINPRM_BUF_SIZE) {
		__u32 s = p + i;
		char c;

		/* A line that runs off bprm->buf has been truncated. */
		if (s >= BINPRM_BUF_SIZE) {
			return -ENOEXEC;
		}
		c = sc->line[s];
		if (is_line_end(c)) {
			break;
		}
		sc->arg[i & (BINPRM_BUF_SIZE - 1)] = c;
		alen = i + 1;
	}

	/* Trailing blanks are not part of the argument. */
	bpf_for(i, 0, BINPRM_BUF_SIZE) {
		if (alen == 0) {
			break;
		}
		if (!is_blank(sc->arg[(alen - 1) & (BINPRM_BUF_SIZE - 1)])) {
			break;
		}
		alen--;
	}
	sc->arg[alen & (BINPRM_BUF_SIZE - 1)] = '\0';

	return ilen + 1;
}

/*
 * Claim "#!" scripts carrying a relocatable interpreter line. Ordinary
 * scripts are declined so binfmt_script handles them.
 */
SEC("struct_ops.s/match")
bool BPF_PROG(script_origin_match, struct linux_binprm *bprm)
{
	__u64 id = bpf_get_current_pid_tgid();
	struct scratch *sc;
	bool ours;

	/* Cheap reject straight from the prefetched header. */
	if (bprm->buf[0] != '#' || bprm->buf[1] != '!') {
		return false;
	}

	sc = scratch_get(id);
	if (!sc) {
		return false;
	}
	copy_header(bprm, sc);
	ours = parse_origin_shebang(sc) > 0;
	bpf_map_delete_elem(&scratch_map, &id);

	return ours;
}

/*
 * Resolve the relocatable interpreter against the script's directory and
 * hand the script to it the same way binfmt_script would.
 */
SEC("struct_ops.s/load")
int BPF_PROG(script_origin_load, struct linux_binprm *bprm)
{
	__u64 id = bpf_get_current_pid_tgid();
	struct scratch *sc;
	int ret, isz;

	sc = scratch_get(id);
	if (!sc) {
		return -ENOEXEC;
	}

	/* Parse the header again; the match left nothing behind. */
	copy_header(bprm, sc);
	isz = parse_origin_shebang(sc);
	if (isz < 0) {
		ret = isz;
		goto out;
	}

	/* From here on the script is ours and failures fail the exec. */
	ret = origin_resolve(bprm, sc, isz);
	if (ret < 0) {
		goto out;
	}
	ret = bpf_binprm_set_interp(bprm, sc->path, sizeof(sc->path));
	if (ret) {
		goto out;
	}

	/* Pass the optional "#!" argument ahead of the script path. */
	if (sc->arg[0] != '\0') {
		ret = bpf_binprm_set_interp_arg(bprm, sc->arg, sizeof(sc->arg));
	}

out:
	bpf_map_delete_elem(&scratch_map, &id);
	return ret;
}

SEC(".struct_ops.link")
struct binfmt_misc_ops script_origin = {
	.match = (void *)script_origin_match,
	.load = (void *)script_origin_load,
	.name = "script_origin",
};
