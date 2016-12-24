{ stdenv, fetchgit, patchutils }:

stdenv.mkDerivation rec {
  name = "mpathconf-${version}";
  version = "0.4.9.83";

  src = fetchgit {
    url = "http://pkgs.fedoraproject.org/git/rpms/device-mapper-multipath.git";
    rev = "906e1e11285fc41097fd89893227664addb00848";
    sha256 = "153cfsb4y5c4a415bahyspb88xj8bshdmiwk8aik72xni546zvid";
  };

  specfile = "device-mapper-multipath.spec";

  phases = [ "unpackPhase" "patchPhase" "installPhase" "fixupPhase" ];

  prePatch = ''
    newPatches="$(sed -n -e 's/^Patch[0-9]\+: *//p' "$specfile")"
    for patch in $newPatches; do
      "${patchutils}/bin/filterdiff" \
        -i '*/multipath/mpathconf' \
        -i '*/multipath/mpathconf.[0-9]*' \
        "$patch" > "$patch.tmp"
      mv "$patch.tmp" "$patch"
    done
    patches="$patches $newPatches"
  '';

  installPhase = ''
    install -vD multipath/mpathconf "$out/bin/mpathconf"
    for manpage in multipath/*.[0-9]*; do
      num="''${manpage##*.}"
      install -m 644 -vD "$manpage" "$out/share/man/man$num/$manpage"
    done
  '';

  meta = {
    homepage = "http://pkgs.fedoraproject.org/cgit/device-mapper-multipath.git";
    description = "Simple editing of /etc/multipath.conf";
    license = stdenv.lib.licenses.gpl2;
  };
}
