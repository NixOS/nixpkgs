// SPDX-License-Identifier: GPL-2.0
/*
 * elf_origin.bpf.c - $ORIGIN-relative ELF loaders for binfmt_misc
 *
 * A binfmt_misc_ops handler for relocatable ELF64 binaries. The loader of
 * such a binary is named relative to the directory holding the binary,
 * in one of two places:
 *
 *  - a PT_INTERP_ORIGIN program header whose contents are
 *    "$ORIGIN/<path>\0". PT_INTERP keeps an absolute path, so the binary
 *    still runs on kernels without this handler as long as that path
 *    exists. PT_INTERP_ORIGIN is preferred when both are present.
 *
 *  - PT_INTERP itself starting with "$ORIGIN/". Such a binary only runs
 *    with this handler loaded.
 *
 * The loader is substituted with BPF_BINPRM_LOADER, so the binary runs as
 * a native exec: argv, /proc/self/exe, AT_SECURE and the address space
 * layout are exactly as if the kernel had found the loader itself.
 *
 * PT_INTERP_ORIGIN is not a standardised program header type. Its value
 * lives in the OS-specific range (PT_LOOS..PT_HIOS) and is set at build
 * time with -DPT_INTERP_ORIGIN=<value>.
 */
#include "origin.h"

char _license[] SEC("license") = "GPL";

#ifndef PT_INTERP_ORIGIN
#define PT_INTERP_ORIGIN	0x6f726967	/* "orig" */
#endif

/*
 * e_machine of the architecture the handler runs on. Loader substitution
 * only works for native binaries, so foreign ones are left to other
 * binfmt_misc entries such as qemu-user.
 */
#ifndef ELF_MACHINE
#error "ELF_MACHINE must be set to the native e_machine value"
#endif

#define PT_INTERP		3
#define EI_CLASS		4
#define ELFCLASS64		2

/* Is the prefetched header that of an ELF64 file? */
static __always_inline bool is_elf64(struct linux_binprm *bprm)
{
	return bprm->buf[0] == 0x7f && bprm->buf[1] == 'E' &&
	       bprm->buf[2] == 'L' && bprm->buf[3] == 'F' &&
	       bprm->buf[EI_CLASS] == ELFCLASS64;
}

/* Does the segment described by @phdr start with "$ORIGIN/"? */
static __always_inline bool segment_has_origin(struct bpf_dynptr *dp,
					       const struct elf64_phdr *phdr)
{
	char prefix[ORIGIN_LEN + 1];

	if (phdr->p_filesz < ORIGIN_MIN_SIZE) {
		return false;
	}
	if (bpf_dynptr_read(prefix, sizeof(prefix), dp, phdr->p_offset, 0)) {
		return false;
	}

	return has_origin_prefix(prefix);
}

/*
 * Find the program header naming an "$ORIGIN/..." loader and copy it to
 * @out. A matching PT_INTERP_ORIGIN wins over a matching PT_INTERP.
 */
static __always_inline bool find_origin_phdr(struct bpf_dynptr *dp,
					     struct elf64_phdr *out)
{
	struct elf64_phdr phdr;
	struct elf64_hdr ehdr;
	bool found = false;
	int i;

	/* Only well-formed native ELF64 program header tables are walked. */
	if (bpf_dynptr_read(&ehdr, sizeof(ehdr), dp, 0, 0)) {
		return false;
	}
	if (ehdr.e_machine != ELF_MACHINE) {
		return false;
	}
	if (ehdr.e_phentsize != sizeof(struct elf64_phdr)) {
		return false;
	}

	bpf_for(i, 0, ehdr.e_phnum) {
		if (i >= MAX_PHDRS) {
			break;
		}
		if (bpf_dynptr_read(&phdr, sizeof(phdr), dp,
				    ehdr.e_phoff + i * sizeof(phdr), 0)) {
			return false;
		}

		/* The relocatable header is authoritative; stop looking. */
		if (phdr.p_type == PT_INTERP_ORIGIN) {
			if (!segment_has_origin(dp, &phdr)) {
				continue;
			}
			*out = phdr;
			found = true;
			break;
		}

		/* Remember an "$ORIGIN/" PT_INTERP, but keep scanning. */
		if (phdr.p_type == PT_INTERP && !found &&
		    segment_has_origin(dp, &phdr)) {
			*out = phdr;
			found = true;
		}
	}

	return found;
}

/*
 * Claim ELF64 binaries that name an "$ORIGIN/" loader. Everything else is
 * declined here, so later binfmt_misc entries and binfmt_elf see it as if
 * this handler did not exist.
 */
SEC("struct_ops.s/match")
bool BPF_PROG(elf_origin_match, struct linux_binprm *bprm)
{
	struct elf64_phdr phdr;
	struct bpf_dynptr dp;
	bool ours = false;

	if (!is_elf64(bprm)) {
		return false;
	}

	/* The dynptr must be discarded on every path once requested. */
	if (!bpf_dynptr_from_file(bprm->file, 0, &dp)) {
		ours = find_origin_phdr(&dp, &phdr);
	}
	bpf_dynptr_file_discard(&dp);

	return ours;
}

/*
 * Resolve the "$ORIGIN/" loader against the binary's directory and run
 * the binary natively with that loader. The file is read again: -ENOEXEC
 * only covers a binary that changed since the match and is no longer ours.
 */
SEC("struct_ops.s/load")
int BPF_PROG(elf_origin_load, struct linux_binprm *bprm)
{
	__u64 id = bpf_get_current_pid_tgid();
	struct elf64_phdr phdr;
	struct bpf_dynptr dp;
	struct scratch *sc;
	int ret = -ENOEXEC;
	__u32 isz;

	/* Locate the loader path again. */
	if (bpf_dynptr_from_file(bprm->file, 0, &dp)) {
		goto out;
	}
	if (!find_origin_phdr(&dp, &phdr)) {
		goto out;
	}

	isz = phdr.p_filesz;
	if (isz < ORIGIN_MIN_SIZE || isz >= PATH_MAX) {
		goto out;
	}
	/*
	 * The range check above tests a zero-extended copy of the u64
	 * p_filesz, so the verifier does not carry the bound over to the
	 * dynptr_read() length below. Mask isz to the buffer size (a power of
	 * two) and materialise it with a barrier so the read uses the bounded
	 * register.
	 */
	isz &= PATH_MAX - 1;
	barrier_var(isz);

	sc = scratch_get(id);
	if (!sc) {
		goto out_del;
	}

	/* Copy the loader path and check it is still "$ORIGIN/...\0". */
	if (bpf_dynptr_read(sc->interp, isz, &dp, phdr.p_offset, 0)) {
		goto out_del;
	}
	/*
	 * The verifier only knows isz is in [0, PATH_MAX) after the mask, so
	 * isz - 1 could wrap. Masking the index again keeps it in bounds; for
	 * the isz values that get here the mask leaves isz - 1 unchanged.
	 */
	if (sc->interp[(isz - 1) & (PATH_MAX - 1)] != '\0') {
		goto out_del;
	}
	if (!has_origin_prefix(sc->interp)) {
		goto out_del;
	}

	/*
	 * From here on failures fail the exec. Falling back to binfmt_elf
	 * would resolve a literal "$ORIGIN/..." PT_INTERP against the
	 * caller's working directory.
	 */
	ret = origin_resolve(bprm, sc, isz);
	if (ret < 0) {
		goto out_del;
	}

	/* Run the binary itself with the resolved loader in place. */
	ret = bpf_binprm_set_flags(bprm, BPF_BINPRM_LOADER);
	if (ret) {
		goto out_del;
	}
	ret = bpf_binprm_set_interp(bprm, sc->path, sizeof(sc->path));

out_del:
	bpf_map_delete_elem(&scratch_map, &id);
out:
	bpf_dynptr_file_discard(&dp);
	return ret;
}

SEC(".struct_ops.link")
struct binfmt_misc_ops elf_origin = {
	.match = (void *)elf_origin_match,
	.load = (void *)elf_origin_load,
	.name = "elf_origin",
};
