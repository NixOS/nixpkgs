# Based on: https://github.com/tokiclover/bar-overlay/blob/ddd118f571a63160c0517e7108aefcbba79d969e/eclass/ecnij.eclass
# With the following license:
# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Original author: tokiclover <tokiclover@gmail.com>

# Set up environment
PV=$version
D=$out
ED=$out
die() { echo "$*" 1>&2 ; exit 1; }

# Internal wrapper to handle subdir phase {prepare,config,compilation...}
dir_src_command()
{
	(( $# < 1 )) && die "Invalid number of argument"

	for dir in "${DIRS[@]}"; do
		echo $dir
		pushd ${dir} || die
		case "${1}" in
			(autoreconf)
			[[ -d po ]] && echo "no" | glib-gettextize --force --copy
			[[ ! -e configure.in ]] && [[ -e configures/configure.in.new ]] &&
				mv -f configures/configure.in.new configure.in
			"${@}"
			;;
			(./configure)
			case ${dir} in
				(backendnet|cnijnpr|lgmon2)
					myconfargs=(
						"--enable-progpath=$out/bin"
						"--enable-libpath=$out/lib/cnijlib"
						"${myconfargs[@]}"
					)
				;;
				(backend|cngpiji*|cnijbe|lgmon|pstocanonij)
					myconfargs=(
						"--enable-progpath=$out/bin"
						"${myconfargs[@]}"
					)
				;;
			esac
			"${@}" "${myconfargs[@]}"
			;;
			(*)
			echo "RUNNING: " "${@}"
			"${@}"
			;;
		esac
		popd || die
	done
}

ecnij_pkg_setup()
{
	CNIJFILTER_SRC+=( libs pstocanonij )
	PRINTER_SRC+=( cnijfilter )
	CNIJFILTER_SRC+=( backend )
	CNIJFILTER_SRC+=( backendnet )
	(( ${PV:0:1} >= 3 )) || ( (( ${PV:0:1} == 2 )) && (( ${PV:2:2} >= 80 )) ) &&
		CNIJFILTER_SRC+=( backend )
	CNIJFILTER_SRC+=( cngpij )
	if (( ${PV:0:1} == 4 )); then
		PRINTER_SRC+=( lgmon2 )
		PRINTER_SRC+=( cnijnpr )
	else
		PRINTER_SRC+=( lgmon cngpijmon )
		PRINTER_SRC+=( cngpijmon/cnijnpr )
	fi

	if (( ${PV:0:1} == 4 )); then
		CNIJFILTER_SRC+=( cngpijmnt )
	elif (( ${PV:0:1} == 3 )) && (( ${PV:2:2} >= 80 )); then
		CNIJFILTER_SRC+=( cngpijmnt maintenance )
	else
		PRINTER_SRC+=( printui )
	fi

	if (( ${PV:0:1} == 4 )); then
		PRINTER_SRC=( bscc2sts "${PRINTER_SRC[@]}" )
		CNIJFILTER_SRC=( cmdtocanonij "${CNIJFILTER_SRC[@]}" cnijbe )
	fi
}

ecnij_src_unpack()
{
	debug-print-function ${FUNCNAME} "${@}"

	default
	mv ${PN}-* ${P} || die "Failed to unpack"
	cd "${S}"
}

ecnij_src_prepare()
{
	local -a DIRS

	DIRS=("${CNIJFILTER_SRC[@]}")
	dir_src_command "autoreconf" -i

	local p pr prid
	for (( p=0; p<${#PRINTER_ID[@]}; p++ )); do
		pr=${PRINTER_MODEL[$p]} prid=${PRINTER_ID[$p]}
		mkdir ${pr} || die
		cp -a ${prid} "${PRINTER_SRC[@]}" ${pr} || die "Failed to copy source files"
		pushd ${pr} || die
		[[ -d ../com ]] && ln -s {../,}com
		DIRS=("${PRINTER_SRC[@]}")
		dir_src_command "autoreconf" -i
		popd
	done
}

ecnij_src_configure()
{
	local -a DIRS

	DIRS=("${CNIJFILTER_SRC[@]}")
	dir_src_command "./configure" "--prefix=/"

	local p pr prid
	for (( p=0; p<${#PRINTER_ID[@]}; p++ )); do
		pr=${PRINTER_MODEL[$p]} prid=${PRINTER_ID[$p]}
		pushd ${pr} || die
		DIRS=("${PRINTER_SRC[@]}")
		dir_src_command "./configure" "--program-suffix=${pr}" "--prefix=/"
		popd
	done
}

# @FUNCTION: ecnij_src_compile
# @DESCRIPTION:
# The base exported src_compile() function
ecnij_src_compile() {
	local -a DIRS

	local p pr prid
	for (( p=0; p<${#PRINTER_ID[@]}; p++ )); do
		pr=${PRINTER_MODEL[$p]} prid=${PRINTER_ID[$p]}
		pushd ${pr} || die
		DIRS=("${PRINTER_SRC[@]}")
		dir_src_command "make"
		popd
	done

	DIRS=("${CNIJFILTER_SRC[@]}")
	dir_src_command "make"
}

ecnij_src_install()
{
	local -a DIRS

	DIRS=("${CNIJFILTER_SRC[@]}")
	dir_src_command "make" "DESTDIR=\"${D}\"" "install"

	for (( p=0; p<${#PRINTER_ID[@]}; p++ )); do
		pr=${PRINTER_MODEL[$p]} prid=${PRINTER_ID[$p]}
		pushd ${pr} || die
		DIRS=("${PRINTER_SRC[@]}")
		dir_src_command "make" "DESTDIR=\"${D}\"" "install"
		popd
		
		pushd ${prid}/libs_bin${abi_lib} || die
		for lib in lib*.so; do
			[[ -L ${lib} ]] && continue ||
			rm ${lib} && ln -s ${lib}.[0-9]* ${lib}
		done
		popd

		mkdir -p $out/lib $out/bin $out/share/cups/model
		install ${prid}/libs_bin${abi_lib}/*.so* $out/lib
		install ${prid}/database/* -m 0755 $out/bin
		install ppd/canon${pr}.ppd $out/share/cups/model
	done

	pushd com/libs_bin${abi_lib} || die
	for lib in lib*.so; do
		[[ -L ${lib} ]] && continue ||
		rm ${lib} && ln -s ${lib}.[0-9]* ${lib}
	done
	popd

	install com/libs_bin${abi_lib}/*.so* $out/lib
	mkdir -p $out/lib/cnijlib
	install -m555 com/ini/cnnet.ini $out/lib/cnijlib

	if (( ${PV:0:1} == 4 )); then
		mkdir -p "${ED}"/share/${PN} || die
		mv "${ED}"/share/{cmdtocanonij,${PN}} || die
	fi
}

ecnij_pkg_postinst()
{
	# XXX: set up ppd files to use newer CUPS backends
	if (( ${PV:0:1} < 3 )) || ( (( ${PV:0:1} == 3 )) && (( ${PV:2:1} == 0 )) ); then
		use cups || sed 's,cnij_usb,cnijusb,g' -i "${ED}"/share/cups/model/canon*.ppd
	fi
}
