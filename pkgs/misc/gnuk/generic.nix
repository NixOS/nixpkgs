{ stdenv, gcc-arm-embedded, makeWrapper
, python, pythonPackages

# Extra options
, device ? "fsij", vid ? "234b", pid ? "0000"

# Version specific options
, version, src
, ...
}:

stdenv.mkDerivation {
  name = "gnuk-${version}-${device}";

  inherit src;

  nativeBuildInputs = [ gcc-arm-embedded makeWrapper ];
  buildInputs = [ python ] ++ (with pythonPackages; [ pyusb colorama ]);

  configurePhase = ''
    cd src
    patchShebangs configure
    ./configure --vidpid=${vid}:${pid}
  '';

  installPhase = ''
    mkdir -p $out/bin

    find . -name gnuk.bin -exec cp {} $out \;

    #sed -i 's,Exception as e,IOError as e,' ../tool/stlinkv2.py
    sed -i ../tool/stlinkv2.py \
      -e "1a import array" \
      -e "s,\(data_received =\) (),\1 array.array('B'),g" \
      -e "s,\(data_received\) = data_received + \(.*\),\1.extend(\2),g"
    cp ../tool/stlinkv2.py $out/bin/stlinkv2
    wrapProgram $out/bin/stlinkv2 --prefix PYTHONPATH : "$PYTHONPATH"

    # Some useful helpers
    echo "#! ${stdenv.shell} -e" | tee $out/bin/{unlock,flash}
    echo "$out/bin/stlinkv2 -u \$@" >> $out/bin/unlock
    echo "$out/bin/stlinkv2 -b \$@ $out/gnuk.bin" >> $out/bin/flash
    chmod +x $out/bin/{unlock,flash}
  '';

  meta = with stdenv.lib; {
    homepage = http://www.fsij.org/pages/gnuk;
    description = "An implementation of USB cryptographic token for gpg";
    license = licenses.gpl3;
    maintainers = with maintainers; [ wkennington ];
    platforms = with platforms; linux;
  };
}
