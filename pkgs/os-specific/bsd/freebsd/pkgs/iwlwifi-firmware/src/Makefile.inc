KMOD=	${NAME}

FIRMWS=	${NAME}:${NAME}

CLEANFILES+=	${NAME} ${NAME}.fwo ${NAME}.ko.debug ${NAME}.ko.full

${NAME}: ${LINUX_FIRMWARE}/intel/iwlwifi/${NAME}
	cp $? ${.TARGET}
