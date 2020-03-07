{ stdenv, fetchurl
, alsaLib, caps
}:

stdenv.mkDerivation {
  name = "alsaequal";

  src = fetchurl {
    url = "https://thedigitalmachine.net/tools/alsaequal-0.6.tar.bz2";
    sha256 = "1w3g9q5z3nrn3mwdhaq6zsg0jila8d102dgwgrhj9vfx58apsvli";
  };

  buildInputs = [ alsaLib ];

  makeFlags = [ "PREFIX=$(out)" "DESTDIR=$(out)" ];

  patches = [ ./makefile.patch ./false_error.patch ./caps_9.x.patch ];

  postPatch = ''
    sed -i 's#/usr/lib/ladspa/caps\.so#${caps}/lib/ladspa/caps\.so#g' ctl_equal.c pcm_equal.c
  '';

  preInstall = ''
    mkdir -p $out/lib/alsa-lib
  '';

  postInstall = ''
    cat << EOF >> "$out/asoundrc"
    ctl_type.equal {
      lib "$out/lib/alsa-lib/libasound_module_ctl_equal.so"
    }
    pcm_type.equal {
      lib "$out/lib/alsa-lib/libasound_module_pcm_equal.so"
    }

    ctl.equal {
        type equal;
    }

    pcm.plugequal {
        type equal;
        # Modify the line below if you do not
        # want to use sound card 0.
        #slave.pcm "plughw:0,0";
        # by default we want to play from more sources at time:
        slave.pcm "plug:dmix";
    }

    # pcm.equal {
    # If you do not want the equalizer to be your
    # default soundcard comment the following
    # line and uncomment the above line. (You can
    # choose it as the output device by addressing
    # it with specific apps,eg mpg123 -a equal 06.Back_In_Black.mp3)
    pcm.!default {
        type plug;
        slave.pcm plugequal;
    }
    EOF

    mkdir -p "$out/bin"
    cat << EOF >> "$out/bin/alsaequal"
    #!/bin/sh

    [ ! -e "\$HOME/.config/alsaequal" ] && mkdir "\$HOME/.config/alsaequal"
    [ ! -e "\$HOME/.config/alsaequal/.asoundrc" ] && cp "$out/asoundrc" "\$HOME/.config/alsaequal/.asoundrc"

    HOME="\$HOME/.config/alsaequal" alsamixer -D equal "\$@"
    EOF
    chmod 755 "$out/bin/alsaequal"
  '';
}
