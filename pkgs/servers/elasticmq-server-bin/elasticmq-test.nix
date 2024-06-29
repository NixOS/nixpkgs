{ elasticmq-server, python3Packages, runCommand, writeText}:

runCommand "${elasticmq-server.name}-tests" (let
  commonPy = ''
    import boto3
    client = boto3.resource(
      "sqs",
      endpoint_url="http://localhost:9324",
      region_name="elasticmq",
      aws_secret_access_key="x",
      aws_access_key_id="x",
      use_ssl=False,
    )
    queue = client.get_queue_by_name(QueueName="foobar")
  '';
in {
  buildInputs = with python3Packages; [ python boto3 ];
  emqConfig = writeText "emq-test.conf" ''
    generate-node-address = true

    queues {
      foobar {}
    }
  '';
  putMessagePy = writeText "put_message.py" ''
    ${commonPy}
    queue.send_message(MessageBody="bazqux")
  '';
  checkMessagePy = writeText "check_message.py" ''
    ${commonPy}
    messages = queue.receive_messages()
    print(f"Received {messages!r}")
    assert len(messages) == 1
    assert messages[0].body == "bazqux"
  '';
}) ''
  JAVA_TOOL_OPTIONS="-Dconfig.file=$emqConfig" ${elasticmq-server}/bin/elasticmq-server &
  SERVER_PID=$!
  sleep 10

  python $putMessagePy
  python $checkMessagePy
  touch $out

  # needed on darwin
  kill $SERVER_PID
''
