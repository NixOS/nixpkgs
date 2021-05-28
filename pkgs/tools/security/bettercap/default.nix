{ stdenv
, buildGoModule
, fetchFromGitHub
, pkg-config
, libpcap
, libnfnetlink
, libnetfilter_queue
, libusb1
}:

buildGoModule rec {
  pname = "bettercap";
  version = "2.28";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    sha256 = "0aihinn3i3jj350l2rqph7nv3wy4nh4f8syidf77zybjcp9nmcys";
  };

  vendorSha256 = "0yfs1f18d8frbkrshsajzzbj4wh2azd89g2h35wm6wqknvlipwr0";

  doCheck = false;

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libpcap libusb1 ]
    ++ stdenv.lib.optionals stdenv.isLinux [ libnfnetlink libnetfilter_queue ];

  meta = with stdenv.lib; {
    description = "A man in the middle tool";
    longDescription = ''
      BetterCAP is a powerful, flexible and portable tool created to perform various types of MITM attacks against a network, manipulate HTTP, HTTPS and TCP traffic in realtime, sniff for credentials and much more.
    '';
    homepage = "https://www.bettercap.org/";
    license = with licenses; gpl3;
    maintainers = with maintainers; [ y0no ];
  };
}
