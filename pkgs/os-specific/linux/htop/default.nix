args: with args;
stdenv.mkDerivation {
	name = "htop-0.6.6";
	src = fetchurl {
		url = mirror://sourceforge/htop/htop-0.6.6.tar.gz;
		sha256 = "1q2jlyxgvx7bj4z0vfvlpq1ap3ykzd9rp598fbpwjw68mwwyzqmj";
	};
	buildInputs = [ncurses];

	meta = {
		description = "An interactive process viewer for Linux";
		homepage = http://htop.sourceforge.net;
	};
}
