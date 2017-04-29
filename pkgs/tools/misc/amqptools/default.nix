{ stdenv, fetchFromGitHub, rabbitmq-c }:

stdenv.mkDerivation {
  name = "amqptools";

  buildInputs = [ rabbitmq-c ];

  src = fetchFromGitHub {
    owner = "rmt";
    repo = "amqptools";
    rev = "ad71013c055c04d158b92e6eafd8efa4b180300a";
    sha256 = "0mjd88kk6j4747gw2z6sm4ng9nnaajgww5n6j02vwxp7325p4c5c";
  };

  setupEnvironment = ''
    export AMQPTOOLS_RABBITHOME=${rabbitmq-c}
    export AMQPTOOLS_INSTALLROOT=$out/bin
    sed -i 's#/librabbitmq/\.libs/#/lib/#g' Makefile
  '';

  preBuildPhases = [ "setupEnvironment" ];

  meta = with stdenv.lib; {
    description = "Command Line Interface for sending and receiving AMQP messages";
    longDescription = ''
      amqpspawn and amqpsend allow the simple sending and receiving of AMQP
      messages from the command line or shell scripts. You will require an
      existing AMQP broker such as RabbitMQ to be running somewhere on an
      accessible network. They use rabbitmq-c and the resident memory footprint
      is under one megabyte, making them perfect for low resource environments.
    '';
    homepage = https://github.com/rmt/amqptools;
    license = licenses.mpl11;
    maintainers = with maintainers; [ apeschar ];
  };
}
