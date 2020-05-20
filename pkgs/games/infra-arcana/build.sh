source $stdenv/setup
PATH=${cmake}/bin:$PATH

configurePhase() {
	:
}

buildPhase() {
	:
}

installPhase() {
	:
}

checkPhase() {
	:
}

fixupPhase() {
	:
}

installCheckPhase() {
	:
}

distPhase() {
	:
}

genericBuild

mkdir build
cd build
CXXFLAGS="-Wno-narrowing" SDL2DIR=$SDL2 SDL2_PATH=$SDL2DEV SDL2_LIBRARY_TEMP=${SDL2}/lib SDL2IMAGEDIR=$SDL2_image SDL2MIXERDIR=$SDL2_mixer cmake -DCMAKE_INSTALL_PREFIX=${out}/ia-bin -DCMAKE_BUILD_TYPE=Release -DSDL2_INCLUDE_DIR=${SDL2DEV}/include/SDL2 $src

make -j${NIX_BUILD_CORES} ia

cd ..

mkdir ${out}

mkdir ${out}/bin

cp -r ./build ${out}/bin

mv ${out}/bin/build ${out}/bin/ia-files

BINDIR=${out}/bin

# Based on 'infra-arcana.sh' script from https://aur.archlinux.org/packages/infra-arcana/
cat << EOF > ${out}/bin/infra-arcana
#!/usr/bin/env bash
cd "${BINDIR}"/ia-files
./ia

EOF

chmod +x ${out}/bin/infra-arcana
