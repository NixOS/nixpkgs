#ifndef _LINUX_VIRTWL_H
#define _LINUX_VIRTWL_H

#include <asm/ioctl.h>
#include <linux/types.h>

#define VIRTWL_SEND_MAX_ALLOCS 28

#define VIRTWL_IOCTL_BASE 'w'
#define VIRTWL_IO(nr) 		_IO(VIRTWL_IOCTL_BASE,nr)
#define VIRTWL_IOR(nr,type)	_IOR(VIRTWL_IOCTL_BASE,nr,type)
#define VIRTWL_IOW(nr,type)	_IOW(VIRTWL_IOCTL_BASE,nr,type)
#define VIRTWL_IOWR(nr,type)	_IOWR(VIRTWL_IOCTL_BASE,nr,type)

enum virtwl_ioctl_new_type {
	VIRTWL_IOCTL_NEW_CTX, /* open a new wayland connection context */
	VIRTWL_IOCTL_NEW_ALLOC, /* create a new virtwl shm allocation */
	VIRTWL_IOCTL_NEW_PIPE_READ, /* create a new virtwl pipe that is readable via the returned fd */
	VIRTWL_IOCTL_NEW_PIPE_WRITE, /* create a new virtwl pipe that is writable via the returned fd */
	VIRTWL_IOCTL_NEW_DMABUF, /* create a new virtwl dmabuf that is writable via the returned fd */
};

struct virtwl_ioctl_new {
	__u32 type; /* VIRTWL_IOCTL_NEW_* */
	int fd; /* return fd */
	__u32 flags; /* currently always 0 */
	union {
		__u32 size; /* size of allocation if type == VIRTWL_IOCTL_NEW_ALLOC */
		struct {
			__u32 width; /* width in pixels */
			__u32 height; /* height in pixels */
			__u32 format; /* fourcc format */
			__u32 stride0; /* return stride0 */
			__u32 stride1; /* return stride1 */
			__u32 stride2; /* return stride2 */
			__u32 offset0; /* return offset0 */
			__u32 offset1; /* return offset1 */
			__u32 offset2; /* return offset2 */
		} dmabuf;
	};
};

struct virtwl_ioctl_txn {
	int fds[VIRTWL_SEND_MAX_ALLOCS];
	__u32 len;
	__u8 data[0];
};

struct virtwl_ioctl_dmabuf_sync {
	__u32 flags; /* synchronization flags (see dma-buf.h) */
};

#define VIRTWL_IOCTL_NEW VIRTWL_IOWR(0x00, struct virtwl_ioctl_new)
#define VIRTWL_IOCTL_SEND VIRTWL_IOR(0x01, struct virtwl_ioctl_txn)
#define VIRTWL_IOCTL_RECV VIRTWL_IOW(0x02, struct virtwl_ioctl_txn)
#define VIRTWL_IOCTL_DMABUF_SYNC VIRTWL_IOR(0x03, \
					    struct virtwl_ioctl_dmabuf_sync)


#endif /* _LINUX_VIRTWL_H */
