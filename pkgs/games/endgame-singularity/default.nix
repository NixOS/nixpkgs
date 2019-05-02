{ stdenv, fetchurl, unzip, python2 }:

python2.pkgs.buildPythonApplication rec {
  pname = "endgame-singularity";
  version = "0.30c";
  format = "other";

  srcs = [
    (fetchurl {
      url = "http://www.emhsoft.com/singularity/singularity-${version}-src.tar.gz";
      sha256 = "13zjhf67gmla67nkfpxb01rxs8j9n4hs0s4n9lnnq4zgb709yxgl";
    })
    (fetchurl {
      url = "http://www.emhsoft.com/singularity/endgame-singularity-music-007.zip";
      sha256 = "0vf2qaf66jh56728pq1zbnw50yckjz6pf6c6qw6dl7vk60kkqnpb";
    })
  ];
  sourceRoot = ".";

  nativeBuildInputs = [ unzip ]; # The music is zipped
  propagatedBuildInputs = with python2.pkgs; [ pygame numpy ];

  # This is not an error: it needs both compilation rounds
  buildPhase = ''
    ${python2.interpreter} -m compileall "singularity-${version}"
    ${python2.interpreter} -O -m compileall "singularity-${version}"
  '';

  installPhase = ''
    install -Dm755 "singularity-${version}/singularity.py"  "$out/share/singularity.py"
    install -Dm644 "singularity-${version}/singularity.pyo" "$out/share/singularity.pyo"
    install -Dm644 "singularity-${version}/singularity.pyc" "$out/share/singularity.pyc"
    cp -R "singularity-${version}/code" "singularity-${version}/data" "$out/share/"
    cp -R "endgame-singularity-music-007" "$out/share/music"
  '';

  # Tell it where to find python libraries
  # Also cd to the same directory as the code, since it uses relative paths
  postFixup = ''
    makeWrapper "${python2.interpreter}" "$out/bin/endgame-singularity" \
          --set PYTHONPATH "$PYTHONPATH" \
          --run "cd \"$out/share\"" \
          --add-flags "$out/share/singularity.py"
  '';

  meta = {
    homepage = http://www.emhsoft.com/singularity/;
    description = "A simulation game about strong AI";
    longDescription = ''
      A simulation of a true AI. Go from computer to computer, pursued by the
      entire world. Keep hidden, and you might have a chance
    '';
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [ fgaz ];
  };
}
