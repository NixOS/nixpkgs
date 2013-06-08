/*
btrfs receive currently mandates that incremental receives can only be performed on a parent subvolume
that was also received. This means you cannot apply it to (snapshotted) subvolumes you still have on disk, 
as they were not received themselves.

This small utility allows you to set the received_uuid of a subvolume, tricking btrfs receive into using it.

found on btrfs mailing list
read the discussion here: http://comments.gmane.org/gmane.comp.file-systems.btrfs/21922
*/

#define _GNU_SOURCE

#include <unistd.h>
#include <stdlib.h>
#include <errno.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <uuid/uuid.h>
#include <sys/ioctl.h>

#include "ctree.h"
#include "ioctl.h"
#include "send-utils.h"

#define CLEAR(var) memset(&var, 0, sizeof(var))


int main(int argc, char **argv) {
	int ret, fd;
	struct subvol_uuid_search sus;
	struct btrfs_ioctl_received_subvol_args rs_args;
	struct subvol_info *si;
	char uuidbuf[37], parent_uuidbuf[37], received_uuidbuf[37];


	if (argc != 3 && argc != 4) {
		printf("usage: btrfs-set-received-uuid btrfs-mountpoint src-subvolume-path-relative-to-mountpoint [dest-absolute-subvolume-path]\n");
		exit(1);
	}

	printf("opening srcmnt %s\n", argv[1]);
	fd = open(argv[1], O_RDONLY | O_NOATIME);
	if (fd < 0) {
		printf("failed to open srcmnt %s! %s\n", argv[1], strerror(errno));
		exit(2);
	}

	puts("initializing sub search");
	CLEAR(sus);
	ret = subvol_uuid_search_init(fd, &sus);
	if (ret < 0) {
		printf("failed to initialize sub search! %s\n", strerror(-ret));
		exit(3);
	}
	
	printf("searching srcsub %s\n", argv[2]);
	si = subvol_uuid_search(&sus, 0, NULL, 0, argv[2], subvol_search_by_path);
	if (!si) {
		puts("srcsub not found!");
		exit(4);
	}

	uuid_unparse(si->uuid,                   uuidbuf);
	uuid_unparse(si->parent_uuid,     parent_uuidbuf);
	uuid_unparse(si->received_uuid, received_uuidbuf);

	printf("\nsrcsub found:\n"
	       "         uuid=%s\n"
	       "  parent_uuid=%s\n"
	       "received_uuid=%s\n"
	       "ctransid=%Lu otransid=%Lu stransid=%Lu rtransid=%Lu\n\n",
	       uuidbuf, parent_uuidbuf, received_uuidbuf,
	       (unsigned long long)(si->ctransid),
	       (unsigned long long)(si->otransid),
	       (unsigned long long)(si->stransid),
	       (unsigned long long)(si->rtransid));

	if (argc == 3)
		goto done;

	printf("opening dst subvol %s\n", argv[3]);
	fd = open(argv[3], O_RDONLY | O_NOATIME);
	if (fd < 0) {
		printf("failed to open dst subvol %s. %s\n", argv[3], strerror(errno));
		exit(5);
	}

	printf("\nhere we go with BTRFS_IOC_SET_RECEIVED_SUBVOL:\n"
	       "dstsub.received_uuid = srcsub.uuid == %s\n"
	       "dstsub.stransid = srcsub.ctransid == %Lu\n\n",
	       uuidbuf, (unsigned long long)(si->ctransid));

	CLEAR(rs_args);
	memcpy(rs_args.uuid, si->uuid, BTRFS_UUID_SIZE);
	rs_args.stransid = si->ctransid;

	ret = ioctl(fd, BTRFS_IOC_SET_RECEIVED_SUBVOL, &rs_args);
	if (ret < 0) {
		printf("BTRFS_IOC_SET_RECEIVED_SUBVOL failed: %s", strerror(-ret));
		exit(6);
	}

done:
	printf("done.\n");
	exit(0);
}
