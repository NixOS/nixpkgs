{ stdenv, fetchzip, freeglut, libGL, libGLU }:

let version = "0.0.5"; in
stdenv.mkDerivation {
      name = "hdaps-gl-${version}";
      src = fetchzip {
            url = "mirror://sourceforge/project/hdaps/hdaps-gl/hdaps-gl-${version}/hdaps-gl-${version}.tar.gz";
            sha256 = "16fk4k0lvr4c95vd6c7qdylcqa1h5yjp3xm4xwipdjbp0bvsgxq4";
      };

      buildInputs = [ freeglut libGL libGLU ];

      # the Makefile has no install target
      installPhase = ''
            install -Dt $out/bin ./hdaps-gl
      '';

      meta = with stdenv.lib; {
            description = "GL-based laptop model that rotates in real-time via hdaps";
            homepage = https://sourceforge.net/projects/hdaps/;
            license = licenses.gpl2;
            platforms = platforms.linux;
            maintainers = [ maintainers.symphorien ];
      };
}
