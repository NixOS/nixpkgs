{ fetchzip
, lib
}:

let
  version = "1.0-RC1";

in
fetchzip rec {
  name = "DirBuster-${version}";

  url = "mirror://sourceforge/dirbuster/DirBuster%20%28jar%20%2B%20lists%29/${version}/${name}.zip";
  sha256 = "sha256-nByEKfhJ5TsZjvL4dTcgrSw0kUUPPVQNJOywdlZwiTo=";

  postFetch = ''
    mkdir -p $out/share/dirbuster
    unzip -j $downloadedFile ${name}/directory-list-\*.txt -d $out/share/dirbuster
  '';

  meta = with lib; {
    homepage = "https://sourceforge.net/projects/dirbuster/";
    license = licenses.cc-by-nc-sa-30;
    maintainers = with maintainers; [ pamplemousse ];
  };
}
