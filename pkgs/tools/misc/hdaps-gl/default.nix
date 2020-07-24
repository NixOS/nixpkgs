{ stdenv, fetchFromGitHub, autoreconfHook, freeglut, libGL, libGLU }:

let version = "0.0.7"; in
stdenv.mkDerivation {
      pname = "hdaps-gl";
      inherit version;
      src = fetchFromGitHub {
            owner = "linux-thinkpad";
            repo = "hdaps-gl";
            rev = version;
            sha256 = "0jywsrcr1wzkjig5cvz014c3r026sbwscbkv7zh1014lkjm0kyyh";
      };

      nativeBuildInputs = [ autoreconfHook ];
      buildInputs = [ freeglut libGL libGLU ];

      meta = with stdenv.lib; {
            description = "GL-based laptop model that rotates in real-time via hdaps";
            homepage = "https://github.com/linux-thinkpad/hdaps-gl";
            license = licenses.gpl2;
            platforms = platforms.linux;
            maintainers = [ maintainers.symphorien ];
      };
}
