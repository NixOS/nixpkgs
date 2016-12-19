{ stdenv, fetchgit, cmake, expat }:

stdenv.mkDerivation rec {
  name = "boomerang-${version}";
  version = "0.3.2alpha";

  src = fetchgit {
    url = "https://github.com/nemerle/boomerang.git";
    rev = "78c6b9dd33790be43dcb07edc549161398904006";
    sha256 = "1n49wx2v9r40mh5kdkspqvc8rccpb4s004qxqvn4fwc59dm0pqbs";
  };

  buildInputs = [ cmake expat ];

  postPatch = ''
    sed -i -e 's/-std=c++0x/-std=c++11 -fpermissive/' CMakeLists.txt

    # Hardcode library base path ("lib/" is appended elsewhere)
    sed -i -e 's|::m_base_path = "|&'"$out"'/|' loader/BinaryFileFactory.cpp
    # Deactivate setting base path at runtime
    sed -i -e 's/m_base_path *=[^}]*//' include/BinaryFile.h

    # Fix up shared directory locations
    shared="$out/share/boomerang/"
    find frontend -name '*.cpp' -print | xargs sed -i -e \
      's|Boomerang::get()->getProgPath()|std::string("'"$shared"'")|'

    cat >> loader/CMakeLists.txt <<CMAKE
    INSTALL(TARGETS bffDump BinaryFile
            ElfBinaryFile Win32BinaryFile ExeBinaryFile HpSomBinaryFile
            PalmBinaryFile DOS4GWBinaryFile MachOBinaryFile
            RUNTIME DESTINATION bin
            LIBRARY DESTINATION lib)
    CMAKE

    cat >> CMakeLists.txt <<CMAKE
    INSTALL(TARGETS boomerang DESTINATION bin)
    INSTALL(DIRECTORY signatures DESTINATION share/boomerang)
    INSTALL(DIRECTORY frontend/machine DESTINATION share/boomerang/frontend)
    CMAKE
  '';

  enableParallelBuilding = true;

  meta = {
    homepage = "http://boomerang.sourceforge.net/";
    license = stdenv.lib.licenses.bsd3;
    description = "A general, open source, retargetable decompiler";
  };
}
