source "$stdenv/setup"

tar zxvf "$src" &&
cd vpnc-*.*

cat config.c |								\
sed "s|/etc/vpnc/vpnc-script|$out/etc/vpnc/vpnc-script|g" > ,,tmp &&	\
mv ,,tmp config.c &&							\
patchPhase && buildPhase && installPhase && fixupPhase && distPhase
