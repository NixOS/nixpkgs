{stdenv, makeWrapper, ed, libopensc_dnie}:

let
   opensc = libopensc_dnie.opensc;
in
stdenv.mkDerivation rec {
  name = "${opensc.name}-dnie-wrapper";

  buildInputs = [ makeWrapper ];
  
  phases = [ "installPhase" ];

  installPhase = ''
    ensureDir $out/etc
    cp ${opensc}/etc/opensc.conf $out/etc
    chmod +w $out/etc/opensc.conf

    # NOTE: The libopensc-dnie.so driver requires /usr/bin/pinentry available, to sign

    ${ed}/bin/ed $out/etc/opensc.conf << EOF
    /card_drivers
    a
    card_drivers = dnie;
    card_driver dnie {
      module = ${libopensc_dnie}/lib/libopensc-dnie.so;
    }
    .
    w
    q
    EOF

    # Disable pkcs15 file caching, otherwise the card does not work
    sed -i 's/use_caching = true/use_caching = false/' $out/etc/opensc.conf

    for a in ${opensc}/bin/*; do
      makeWrapper $a $out/bin/`basename $a` \
        --set OPENSC_CONF $out/etc/opensc.conf
    done

    # Special wrapper for pkcs11-tool, which needs an additional parameter
    rm $out/bin/pkcs11-tool
    makeWrapper ${opensc}/bin/pkcs11-tool $out/bin/pkcs11-tool \
      --set OPENSC_CONF $out/etc/opensc.conf \
      --add-flags "--module ${opensc}/lib/opensc-pkcs11.so"

    # Add, as bonus, a wrapper for the firefox in the PATH, that loads the
    # proper opensc configuration.
    cat > $out/bin/firefox-dnie << EOF
    #!${stdenv.shell}
    export OPENSC_CONF=$out/etc/opensc.conf
    exec firefox
    EOF
    chmod +x $out/bin/firefox-dnie
  '';

  meta = {
    description = "Access to the opensc tools and firefox using the Spanish national ID SmartCard";
    longDescription = ''
      Opensc needs a special configuration and special drivers to use the SmartCard
      the Spanish governement provides to the citizens as ID card.
      Some wrapper scripts take care for the proper opensc configuration to be used, in order
      to access the certificates in the SmartCard through the opensc tools or firefox.
      Opensc will require a pcscd daemon running, managing the access to the card reader.
    '';
    maintainers = with stdenv.lib.maintainers; [viric];
  };
}
