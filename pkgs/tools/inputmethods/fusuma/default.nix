{ lib, bundlerApp, makeWrapper, libinput }:

bundlerApp {
  pname = "fusuma";
  gemdir = ./.;
  exes = [ "fusuma" ];

  buildInputs = [ makeWrapper ];

  postBuild = ''
    wrapProgram "$out/bin/fusuma" \
      --prefix PATH : ${lib.makeBinPath [ libinput ]}
  '';

  meta = with lib; {
    description = "Multitouch gestures with libinput driver on X11, Linux";
    homepage    = https://github.com/iberianpig/fusuma;
    license     = licenses.mit;
    maintainers = with maintainers; [ jfrankenau ];
    platforms   = platforms.linux;
  };
}
