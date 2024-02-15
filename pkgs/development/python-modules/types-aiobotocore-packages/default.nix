{ lib
, buildPythonPackage
, pythonOlder
, aiobotocore
, botocore
, typing-extensions
, fetchPypi
}:
let
  toUnderscore = str: builtins.replaceStrings [ "-" ] [ "_" ] str;

  buildTypesAiobotocorePackage = serviceName: version: hash:
    buildPythonPackage rec {
      pname = "types-aiobotocore-${serviceName}";
      inherit version;
      format = "setuptools";

      disabled = pythonOlder "3.7";

      src = fetchPypi {
        inherit pname version hash;
      };

      propagatedBuildInputs = [
        aiobotocore
        botocore
      ] ++ lib.optionals (pythonOlder "3.12") [
        typing-extensions
      ];

      # Project has no tests
      doCheck = false;

      pythonImportsCheck = [
        "types_aiobotocore_${toUnderscore serviceName}"
      ];

      meta = with lib; {
        description = "Type annotations for aiobotocore ${serviceName}";
        homepage = "https://github.com/youtype/mypy_boto3_builder";
        license = with licenses; [ mit ];
        maintainers = with maintainers; [ mbalatsko ];
      };
    };
in
rec {
  types-aiobotocore-accessanalyzer = buildTypesAiobotocorePackage "accessanalyzer" "2.8.0" "sha256-7TmekyZVc2l2er1TIJURP7Qy0n7xRYnXt44FJr5XBWA=";

  types-aiobotocore-account = buildTypesAiobotocorePackage "account" "2.8.0" "sha256-rVwj3gN9+U5m6xXwytQpE8mSVPTlezzeNIwNH2vgR4Y=";

  types-aiobotocore-acm = buildTypesAiobotocorePackage "acm" "2.8.0" "sha256-VzV8viXJpHfI1aD1UtCX+GSSZKhRSTzMX5dnkGhm+9Y=";

  types-aiobotocore-acm-pca = buildTypesAiobotocorePackage "acm-pca" "2.8.0" "sha256-ib044RjF+1projrSoyiMdj9LkbT1BJrfObxs1ukSNHo=";

  types-aiobotocore-alexaforbusiness = buildTypesAiobotocorePackage "alexaforbusiness" "2.11.2" "sha256-XUzsO3dJmVEyAkwGcZ9BxNb8CceJALCNRIfs6/lFa8M=";

  types-aiobotocore-amp = buildTypesAiobotocorePackage "amp" "2.11.2" "sha256-hFZPPMjFeQ8YuDV27uuQudFkKaXPaOkEWEbGrEp7nsc=";

  types-aiobotocore-amplify = buildTypesAiobotocorePackage "amplify" "2.11.2" "sha256-p11NN4Iohj0Rpx7ZWnLKHP64DAKzg5CfwQ5DV2UtRqk=";

  types-aiobotocore-amplifybackend = buildTypesAiobotocorePackage "amplifybackend" "2.11.2" "sha256-vG15+IbQZSoSeXPgZw2YgKFtu6vVLgwHrnvXbUOu7ow=";

  types-aiobotocore-amplifyuibuilder = buildTypesAiobotocorePackage "amplifyuibuilder" "2.11.2" "sha256-WazM6zeqExvUzf6edTg79q5ghSbCFS+4emllnp2/nGs=";

  types-aiobotocore-apigateway = buildTypesAiobotocorePackage "apigateway" "2.11.2" "sha256-pb13E6ybvZrt1NfYFqPzkXYSxqFVUuE9Ka3LK6oLLB8=";

  types-aiobotocore-apigatewaymanagementapi = buildTypesAiobotocorePackage "apigatewaymanagementapi" "2.11.2" "sha256-Zgv4BfnwMjZTWnnkvSIZx7jEcYDg088Po8wS3YNnscE=";

  types-aiobotocore-apigatewayv2 = buildTypesAiobotocorePackage "apigatewayv2" "2.11.2" "sha256-kQIc0DS8mgBdBBncavFLo6gYoQbqNzgbhzfN7ZRmZU0=";

  types-aiobotocore-appconfig = buildTypesAiobotocorePackage "appconfig" "2.11.2" "sha256-ufFeadCeUuzQlVZEoHKC2bdgsnCni4bUlOVII3P0ydQ=";

  types-aiobotocore-appconfigdata = buildTypesAiobotocorePackage "appconfigdata" "2.11.2" "sha256-D6wk/D18H5DSv9rzu61GtO0b4sLUsAbAgDThxM/LXaw=";

  types-aiobotocore-appfabric = buildTypesAiobotocorePackage "appfabric" "2.11.2" "sha256-jvO9GCkF6HC7Y/Gallc0unmk0ZX5C6uZDGmxwiHAMCs=";

  types-aiobotocore-appflow = buildTypesAiobotocorePackage "appflow" "2.11.2" "sha256-Kvu5+auFG7FDR1w/6xv7JWJkEwM+wuaXJHIDIUOgxsg=";

  types-aiobotocore-appintegrations = buildTypesAiobotocorePackage "appintegrations" "2.11.2" "sha256-nyJNZejMFYBgTJGjM+ylfHVilA/KrZJ9mJa1m4Ej/i0=";

  types-aiobotocore-application-autoscaling = buildTypesAiobotocorePackage "application-autoscaling" "2.11.2" "sha256-RrjOGf342giEftdtYrWN9nuHuxGIX7tC2lyi7kFVGZA=";

  types-aiobotocore-application-insights = buildTypesAiobotocorePackage "application-insights" "2.11.2" "sha256-/CRUfLRLggcHpD+H6tsMrJf8kC23qqCtfRUf510MYs8=";

  types-aiobotocore-applicationcostprofiler = buildTypesAiobotocorePackage "applicationcostprofiler" "2.11.2" "sha256-uB+lXza3Zyj5ug/1tr5jxhIYDFmy0u/rbLdHQQW33zs=";

  types-aiobotocore-appmesh = buildTypesAiobotocorePackage "appmesh" "2.11.2" "sha256-ddng69ZZp8lEEKZAEK/9AMPHBaRpQRmbPVQVQgEpWQI=";

  types-aiobotocore-apprunner = buildTypesAiobotocorePackage "apprunner" "2.11.2" "sha256-zn+wgfdLfNzrhmmWaQnnBJw6Mp6FUPSs1Aq4U+QEZZ4=";

  types-aiobotocore-appstream = buildTypesAiobotocorePackage "appstream" "2.11.2" "sha256-97aTTprrNQ5fp1Ap2SgliVhz2FweNcWJxmOVf7NGznQ=";

  types-aiobotocore-appsync = buildTypesAiobotocorePackage "appsync" "2.11.2" "sha256-1d4FgrbxzX5jMZEL7ghT4olTTmy18ZK1zaXDWcBoz3I=";

  types-aiobotocore-arc-zonal-shift = buildTypesAiobotocorePackage "arc-zonal-shift" "2.11.2" "sha256-s9zX+TsBp4DSORJkxZG9VrVmeHuNfeNfv+vZsJXnfSE=";

  types-aiobotocore-athena = buildTypesAiobotocorePackage "athena" "2.11.2" "sha256-MxbYsiBSryODm6ZuJpb0Jwmiw/k679yPxBIGYrFQFfQ=";

  types-aiobotocore-auditmanager = buildTypesAiobotocorePackage "auditmanager" "2.11.2" "sha256-IErQ9xVFHfQKAT4WUvyummuUndVG6azLCflA4e8AcAI=";

  types-aiobotocore-autoscaling = buildTypesAiobotocorePackage "autoscaling" "2.11.2" "sha256-UJxccq20Wy9A3xDDqpDGGs3KtP8uVFK/G8AFvlJblUs=";

  types-aiobotocore-autoscaling-plans = buildTypesAiobotocorePackage "autoscaling-plans" "2.11.2" "sha256-0LzoSmxim0Ji1qVTKz5aaYNF2ZxSxkJPQsZgl6HBvXM=";

  types-aiobotocore-backup = buildTypesAiobotocorePackage "backup" "2.11.2" "sha256-deC72vTE1w4K2vIQeQMb/38CEBHXhP/koEsVBUZQkxU=";

  types-aiobotocore-backup-gateway = buildTypesAiobotocorePackage "backup-gateway" "2.11.2" "sha256-ggjy2SYEDZgqkvBi7N/mZbScwQNOxQR3Je+UsntPaKA=";

  types-aiobotocore-backupstorage = buildTypesAiobotocorePackage "backupstorage" "2.11.2" "sha256-ZtC6TpfMQE48ih14/yMm9UVt/nCjVt6Jza0lakE/t0w=";

  types-aiobotocore-batch = buildTypesAiobotocorePackage "batch" "2.11.2" "sha256-DnZ7/CZ2af+DhHKp6LvsuCLfVu43yiwYFRxugEsMEok=";

  types-aiobotocore-billingconductor = buildTypesAiobotocorePackage "billingconductor" "2.11.2" "sha256-vURVxenciwH3Qwi6FLjsxVkHSVQJ5C63zzb5Npr+Kxo=";

  types-aiobotocore-braket = buildTypesAiobotocorePackage "braket" "2.11.2" "sha256-rdH9EaCMApXDf+3ERvNNsvJBtCEqkjf6XpLHTRn4V4Y=";

  types-aiobotocore-budgets = buildTypesAiobotocorePackage "budgets" "2.11.2" "sha256-zaaeXhic5omexJMc5TVAK+ADqmJxkV9YJkasQCfAf/w=";

  types-aiobotocore-ce = buildTypesAiobotocorePackage "ce" "2.11.2" "sha256-nlsx8TDLKC3bTcuHuqACgtgl4OvTjHHYiYXXlk7gbLE=";

  types-aiobotocore-chime = buildTypesAiobotocorePackage "chime" "2.11.2" "sha256-j+RmGyAMnf8a/OztACdfOr/6a16V+SGDPS+ETl0ZetM=";

  types-aiobotocore-chime-sdk-identity = buildTypesAiobotocorePackage "chime-sdk-identity" "2.11.2" "sha256-5MtREitAmJ/5cSQDJeYj6SilLfspKWZFTmiTaCsv/a0=";

  types-aiobotocore-chime-sdk-media-pipelines = buildTypesAiobotocorePackage "chime-sdk-media-pipelines" "2.11.2" "sha256-JFZ/ijE1FRCEWMF8wFZe5mA5UW1Y0Xh7A7kVAoG4QY0=";

  types-aiobotocore-chime-sdk-meetings = buildTypesAiobotocorePackage "chime-sdk-meetings" "2.11.2" "sha256-FB0X7wR4xvMT9GiyHkDX9lSVxBQVxWs1NG0/rwPpeyg=";

  types-aiobotocore-chime-sdk-messaging = buildTypesAiobotocorePackage "chime-sdk-messaging" "2.11.2" "sha256-IMRhuNevxyg48ahyKSCJ6ytpX3BEZKPG37du+Vm+grk=";

  types-aiobotocore-chime-sdk-voice = buildTypesAiobotocorePackage "chime-sdk-voice" "2.11.2" "sha256-R18RGbDg393B37iuwi3NwEshVzDZ7iTaTX525MMgpoQ=";

  types-aiobotocore-cleanrooms = buildTypesAiobotocorePackage "cleanrooms" "2.11.2" "sha256-AKjMZa6crhEuSl3aHo0op94hlPKKWqXG8w33ipcnuK4=";

  types-aiobotocore-cloud9 = buildTypesAiobotocorePackage "cloud9" "2.11.2" "sha256-ru9I0dKqFsjaNUhAFLrXh+SPN1HaHCFL+2LRS16+pSI=";

  types-aiobotocore-cloudcontrol = buildTypesAiobotocorePackage "cloudcontrol" "2.11.2" "sha256-LwgyZxkvTTFgYWsF2kkK/IxflGpyr2oq2CxCMWnMDpQ=";

  types-aiobotocore-clouddirectory = buildTypesAiobotocorePackage "clouddirectory" "2.11.2" "sha256-0G1EUlW2oDJI0DgsQjZ4NkHIQbKqnvlyMxxrkhj5q8M=";

  types-aiobotocore-cloudformation = buildTypesAiobotocorePackage "cloudformation" "2.11.2" "sha256-QFupRQ8DtSwddqrTVEUrUjLyKChguEnSmYqvicaJJA8=";

  types-aiobotocore-cloudfront = buildTypesAiobotocorePackage "cloudfront" "2.11.2" "sha256-n/cNWP73Qta8lkXnpvtEOU7vO6IR5n1khlY8G2gZHZ4=";

  types-aiobotocore-cloudhsm = buildTypesAiobotocorePackage "cloudhsm" "2.11.2" "sha256-+CRJNZ5W5ZQB7HzlY6IF6fT5a3LF8ES7Cmmts5c8Xjc=";

  types-aiobotocore-cloudhsmv2 = buildTypesAiobotocorePackage "cloudhsmv2" "2.11.2" "sha256-RWoizNbfw+Nujlf2Y4vEgVyyyVqmxkBF3wu4Ox7EsG0=";

  types-aiobotocore-cloudsearch = buildTypesAiobotocorePackage "cloudsearch" "2.11.2" "sha256-VncrELHOiw/z4oQ5JTiXQIR0CZdGtX5xQeei1/JdONY=";

  types-aiobotocore-cloudsearchdomain = buildTypesAiobotocorePackage "cloudsearchdomain" "2.11.2" "sha256-Ei3/wp0zUE5CitvVf135GF4cW7KAbukDYtS8ZOJPwBg=";

  types-aiobotocore-cloudtrail = buildTypesAiobotocorePackage "cloudtrail" "2.11.2" "sha256-YEPoPUFRt+kiMbABD3fg7W2qYRKblmIG4YjbFTQpAdw=";

  types-aiobotocore-cloudtrail-data = buildTypesAiobotocorePackage "cloudtrail-data" "2.11.2" "sha256-3ZLYMHreAEA1j/mp3HJF5rLZ45Nnt5GdQrcFY3Sh434=";

  types-aiobotocore-cloudwatch = buildTypesAiobotocorePackage "cloudwatch" "2.11.2" "sha256-gvJyiNl7u79VejEK5eFhBuC1tYK4tMAhAbsnFEfNhYI=";

  types-aiobotocore-codeartifact = buildTypesAiobotocorePackage "codeartifact" "2.11.2" "sha256-CUiHlJTgSYpYH/6aEyjtsXBbWxFKu4GqTdDn7hP7wHA=";

  types-aiobotocore-codebuild = buildTypesAiobotocorePackage "codebuild" "2.11.2" "sha256-0gs1j3dJ94suVhfieHwNs6xDmUwN/2VAMUP8F9BQcaY=";

  types-aiobotocore-codecatalyst = buildTypesAiobotocorePackage "codecatalyst" "2.11.2" "sha256-7GYiqcO1H1eVojfpfBUHmf7JvePZOAKLu8QSxqTKjH0=";

  types-aiobotocore-codecommit = buildTypesAiobotocorePackage "codecommit" "2.11.2" "sha256-YHisggElD8iq1DTcrZnIzdFrnLAUWFULgGe7jdm3oWY=";

  types-aiobotocore-codedeploy = buildTypesAiobotocorePackage "codedeploy" "2.11.2" "sha256-dkyzpYzga1rjIiUAvAYqmvBotq7cbzgujsEdB1ViTZs=";

  types-aiobotocore-codeguru-reviewer = buildTypesAiobotocorePackage "codeguru-reviewer" "2.11.2" "sha256-hBobZDb4rpMcVkXTWVVRvHTjz+O4num/tLdHc9K+pn0=";

  types-aiobotocore-codeguru-security = buildTypesAiobotocorePackage "codeguru-security" "2.11.2" "sha256-UjhVraSTdP6zQNKK7YF7CiR8Y0IglumyKWo4q4+lYEY=";

  types-aiobotocore-codeguruprofiler = buildTypesAiobotocorePackage "codeguruprofiler" "2.11.2" "sha256-A1MNRLeNmKFZWO9VPlYOPiYI1XfMvxau08eu0kt9XH8=";

  types-aiobotocore-codepipeline = buildTypesAiobotocorePackage "codepipeline" "2.11.2" "sha256-1agFA021Ng2yyGZeR6RfnNiajPwLV1hgGH9mnGi54V4=";

  types-aiobotocore-codestar = buildTypesAiobotocorePackage "codestar" "2.11.2" "sha256-yBc09bY/svyht27FIcSYGkkLyUeHM97IYB4aVWo8CFE=";

  types-aiobotocore-codestar-connections = buildTypesAiobotocorePackage "codestar-connections" "2.11.2" "sha256-RSpNT70XrU8ZLRgTgpqiELV4e0WJTtWCTESdGA4mGQs=";

  types-aiobotocore-codestar-notifications = buildTypesAiobotocorePackage "codestar-notifications" "2.11.2" "sha256-5DiJoLCkRD5GL+uglCSYQAdrAPrHrk9Eoo0TUoFV6ms=";

  types-aiobotocore-cognito-identity = buildTypesAiobotocorePackage "cognito-identity" "2.11.2" "sha256-yf1lZtCRru/n4lWW+8Js75azhW7o1q8dQ7vgwQQpOv0=";

  types-aiobotocore-cognito-idp = buildTypesAiobotocorePackage "cognito-idp" "2.11.2" "sha256-GtrQuQBHzkglEMjkYSGoHrOm/LFAAYhKl2JTUpGCFaE=";

  types-aiobotocore-cognito-sync = buildTypesAiobotocorePackage "cognito-sync" "2.11.2" "sha256-uh+LAEBYuKAK1BJPu6rJtSJcE4TpXV09d9jH20IevOk=";

  types-aiobotocore-comprehend = buildTypesAiobotocorePackage "comprehend" "2.11.2" "sha256-w1FlANcEK/BIDeT+iSJU1FQDidor6bs1w5HNEa1Jj4k=";

  types-aiobotocore-comprehendmedical = buildTypesAiobotocorePackage "comprehendmedical" "2.11.2" "sha256-GqWg0H95Z0wNHaSt1R1GnVTGTyZ3Qki9Du4byRRGmcs=";

  types-aiobotocore-compute-optimizer = buildTypesAiobotocorePackage "compute-optimizer" "2.11.2" "sha256-7TK1QtWs6gVZQO8dTuVs9JG35xlP/4Sk0HCfEDL5cPU=";

  types-aiobotocore-config = buildTypesAiobotocorePackage "config" "2.11.2" "sha256-oBXLOS4TLGd/6cEVwySUNKXTigmEPFhM4vR+uWC/jCA=";

  types-aiobotocore-connect = buildTypesAiobotocorePackage "connect" "2.11.2" "sha256-nRq8rHdQNHpY0O1ft/IOFgiZT+flDoJeYktoIR7azd0=";

  types-aiobotocore-connect-contact-lens = buildTypesAiobotocorePackage "connect-contact-lens" "2.11.2" "sha256-kSSYE9sHHvWyXQD3+h4zwbmpVE4spdFsVajLrs8wQoY=";

  types-aiobotocore-connectcampaigns = buildTypesAiobotocorePackage "connectcampaigns" "2.11.2" "sha256-8h5Uw5dRI0Iq88DKaEkp/QiqsxMpXqT1e0fSCnmeUeQ=";

  types-aiobotocore-connectcases = buildTypesAiobotocorePackage "connectcases" "2.11.2" "sha256-iCunD1EYNwnwEVE5h83cO8DtgQrfqd2XsjmA6/LUyKk=";

  types-aiobotocore-connectparticipant = buildTypesAiobotocorePackage "connectparticipant" "2.11.2" "sha256-3szxg0WTtha1txrfidQUwCnwQ+y6DmaFdyRASxNvyPM=";

  types-aiobotocore-controltower = buildTypesAiobotocorePackage "controltower" "2.11.2" "sha256-Vnc1jV10ylYc1xyIAB05sc6F/mrenB/evzSxUXvksIo=";

  types-aiobotocore-cur = buildTypesAiobotocorePackage "cur" "2.11.2" "sha256-GxnIgMuPdhButM1g0WhIY5aozxRVD9wisFI7vg0htkk=";

  types-aiobotocore-customer-profiles = buildTypesAiobotocorePackage "customer-profiles" "2.11.2" "sha256-32oCCsq7HRgfuQHxtC8To8YRPPkBYxP+wj8tTxJg74Y=";

  types-aiobotocore-databrew = buildTypesAiobotocorePackage "databrew" "2.11.2" "sha256-QezthhLSvyrCjlBDgQFJOLd3jdkvf3gYczusxWARUtM=";

  types-aiobotocore-dataexchange = buildTypesAiobotocorePackage "dataexchange" "2.11.2" "sha256-GZaODMMW3citfIA0EDl8J+Z8T8euCx6pXmm24iL/g90=";

  types-aiobotocore-datapipeline = buildTypesAiobotocorePackage "datapipeline" "2.11.2" "sha256-bkok6yFZG4DOXnweqa1fWxxX5lq4XVN6A/NSrQiAWNI=";

  types-aiobotocore-datasync = buildTypesAiobotocorePackage "datasync" "2.11.2" "sha256-lipzCM0iHpHfggorFc67IIRIA7zQkZOFSrNdkZNc1n0=";

  types-aiobotocore-dax = buildTypesAiobotocorePackage "dax" "2.11.2" "sha256-cmtSKNzaKuDMKpT2e3FxxGAA3s6fXmnp27g8ZjiuW34=";

  types-aiobotocore-detective = buildTypesAiobotocorePackage "detective" "2.11.2" "sha256-+qeNgy9ZCpx2i7aSSBv6vHJAa11j+YqYbu1e5ebTOkY=";

  types-aiobotocore-devicefarm = buildTypesAiobotocorePackage "devicefarm" "2.11.2" "sha256-hJ8ajXMmlmUZmKBDYxkUX1RU/8C3xmjb403YzkVzm6E=";

  types-aiobotocore-devops-guru = buildTypesAiobotocorePackage "devops-guru" "2.11.2" "sha256-1ERoQL1dD2Ia1asRDjF/bl/tnKkaKUhd0JkXfsw9zXY=";

  types-aiobotocore-directconnect = buildTypesAiobotocorePackage "directconnect" "2.11.2" "sha256-EcaX5FjIweqW0hTbhgMm3XFVtnoY/fVt5pAjgm8L0+U=";

  types-aiobotocore-discovery = buildTypesAiobotocorePackage "discovery" "2.11.2" "sha256-ZOPuTLIH9Sqojs2jWiskjEqz7LBstS1KyjPCiSnW0Qo=";

  types-aiobotocore-dlm = buildTypesAiobotocorePackage "dlm" "2.11.2" "sha256-SfzmZe5x4I0TMdfwAu6DFkK2NDgqZrdiXfYzj6FV6/0=";

  types-aiobotocore-dms = buildTypesAiobotocorePackage "dms" "2.11.2" "sha256-1ZEKq3hLceAxXAM7PncqWR/XEri75Moyno/yg0szG+E=";

  types-aiobotocore-docdb = buildTypesAiobotocorePackage "docdb" "2.11.2" "sha256-sFS4uLPnOltigByAzretunrrS/jabDft6tTX68+uXnI=";

  types-aiobotocore-docdb-elastic = buildTypesAiobotocorePackage "docdb-elastic" "2.11.2" "sha256-2Ay4Bx3txzhZMaOwFJRsTt7w3qCr2bS2KsoDg9Apxbk=";

  types-aiobotocore-drs = buildTypesAiobotocorePackage "drs" "2.11.2" "sha256-j1tX8XGhYVRWw3XJosccmWRPLJRzjfoZpEsEWW8KrcU=";

  types-aiobotocore-ds = buildTypesAiobotocorePackage "ds" "2.11.2" "sha256-wUF8YcVlSop62Bqsr3yx7JnlLFOKZFY9ZOQPp+IArOY=";

  types-aiobotocore-dynamodb = buildTypesAiobotocorePackage "dynamodb" "2.11.2" "sha256-nBxKLHdId11mo/0P4LFgKRUoBXum2OHtJO7wjy0yK/o=";

  types-aiobotocore-dynamodbstreams = buildTypesAiobotocorePackage "dynamodbstreams" "2.11.2" "sha256-7/Yt+rhmXoJaTyXv/cApcI6GUE0bqYaIDaLlQr6/vlA=";

  types-aiobotocore-ebs = buildTypesAiobotocorePackage "ebs" "2.11.2" "sha256-g4soKEa22SWyE8Sq7lemBWMEjzvS47Xp3ykQoccWg6A=";

  types-aiobotocore-ec2 = buildTypesAiobotocorePackage "ec2" "2.11.2" "sha256-QbLjyIptZJoKm79byEABhg5TWPjbHTmq2ReibuC22+s=";

  types-aiobotocore-ec2-instance-connect = buildTypesAiobotocorePackage "ec2-instance-connect" "2.11.2" "sha256-pk6rOYhNMnCTxlDpRC+b2TlWCTfr9sVrV/OVaTV4Tzo=";

  types-aiobotocore-ecr = buildTypesAiobotocorePackage "ecr" "2.11.2" "sha256-BJp+XxIXv1LM6nQLyjo7cPHxU02SQHcace2Y4rb14ro=";

  types-aiobotocore-ecr-public = buildTypesAiobotocorePackage "ecr-public" "2.11.2" "sha256-6rVdyPkUOsr6mpfr1jlsbGt9WN+vVsRyzxG/WrpelyQ=";

  types-aiobotocore-ecs = buildTypesAiobotocorePackage "ecs" "2.11.2" "sha256-IvTlBjwLhphGUD/0uMkqePhEwStxj+YPVVMY12ElfvY=";

  types-aiobotocore-efs = buildTypesAiobotocorePackage "efs" "2.11.2" "sha256-jov1KwnZWbuMUpL3OVqrI+EHIR6WResabp20owGIvGA=";

  types-aiobotocore-eks = buildTypesAiobotocorePackage "eks" "2.11.2" "sha256-qTA88Wux/Ns7dHfRPwG1ZFWNTtSUGTcw6L+Nake+YGg=";

  types-aiobotocore-elastic-inference = buildTypesAiobotocorePackage "elastic-inference" "2.11.2" "sha256-POTPmu22698IeVAhpxh2kWk+OwTv2fBSm9KAhJ/MiQg=";

  types-aiobotocore-elasticache = buildTypesAiobotocorePackage "elasticache" "2.11.2" "sha256-LC5g7bf5jAc4Llo6rukPb2WYf5KqvUweQ52u2zsXAQE=";

  types-aiobotocore-elasticbeanstalk = buildTypesAiobotocorePackage "elasticbeanstalk" "2.11.2" "sha256-L3Pti+JnFCFGo+0v82sQK73aHKG5Lgbm6shPCvF4Wug=";

  types-aiobotocore-elastictranscoder = buildTypesAiobotocorePackage "elastictranscoder" "2.11.2" "sha256-PdWptyC6jP53Lv8JDPMbD+KE32nXltpOeXOXt+yBqZk=";

  types-aiobotocore-elb = buildTypesAiobotocorePackage "elb" "2.11.2" "sha256-PzGkhg0Ole3nVSkPzLzGhCXR7O6tQXQI/fyG/xWF5NU=";

  types-aiobotocore-elbv2 = buildTypesAiobotocorePackage "elbv2" "2.11.2" "sha256-pxf7oIi/KDjuAJPKA/blGpBTtSsbW6VQR2GIIG4Xg6I=";

  types-aiobotocore-emr = buildTypesAiobotocorePackage "emr" "2.11.2" "sha256-nI1XjcxmEBZs63d9EO+rQfqyYQMOBJXOdLI+EaNZsgY=";

  types-aiobotocore-emr-containers = buildTypesAiobotocorePackage "emr-containers" "2.11.2" "sha256-i37s9KpOUqbO8xAgFtU0tNlSZUqvxQjI6D2mMmjbTOs=";

  types-aiobotocore-emr-serverless = buildTypesAiobotocorePackage "emr-serverless" "2.11.2" "sha256-gaSCCHUbA5XqpXwls5f6LR9BfA/V4eECsRVfat+tLw0=";

  types-aiobotocore-entityresolution = buildTypesAiobotocorePackage "entityresolution" "2.11.2" "sha256-sKRdHC1b4LhoHMo1ixwIEMFgKzn4oAMf7Hd4kPpAGNA=";

  types-aiobotocore-es = buildTypesAiobotocorePackage "es" "2.11.2" "sha256-2mSA+/Ad1gok69+r7E/euPzKOj82e38Qn+sXWTfvoPk=";

  types-aiobotocore-events = buildTypesAiobotocorePackage "events" "2.11.2" "sha256-tkrTtagj15JMTRSKD6qCqew4zo+i4IOl8KxBtgoREno=";

  types-aiobotocore-evidently = buildTypesAiobotocorePackage "evidently" "2.11.2" "sha256-Cj7UZddP4zWjKehjFL6S7c89hu6lZKe2muZ+vZQYLEA=";

  types-aiobotocore-finspace = buildTypesAiobotocorePackage "finspace" "2.11.2" "sha256-nCFS8zPgut2AUT+e6ZKwa4mP2yUuSyWB4ouuqDZaJZY=";

  types-aiobotocore-finspace-data = buildTypesAiobotocorePackage "finspace-data" "2.11.2" "sha256-5z1ek7Euei7r1XSygNM4qZEaDrGeC4XMFIeGvg9qJV0=";

  types-aiobotocore-firehose = buildTypesAiobotocorePackage "firehose" "2.11.2" "sha256-ATPvNRegT/EjVJCGY7sl6ayiMC8+B0GMyfQEpOnWfyI=";

  types-aiobotocore-fis = buildTypesAiobotocorePackage "fis" "2.11.2" "sha256-PBRTNQeoBf8Sqd4zYQYJ4h/wZWHT1LY1LodceA4SzLU=";

  types-aiobotocore-fms = buildTypesAiobotocorePackage "fms" "2.11.2" "sha256-83W6ys3ZBuC+RINAiqZZ9t9/pJVV6vSqW0w7B6cA9uw=";

  types-aiobotocore-forecast = buildTypesAiobotocorePackage "forecast" "2.11.2" "sha256-nWsEp9VH2JsMnQrVRuALqc6EUjtfkge8E86XB6koHcE=";

  types-aiobotocore-forecastquery = buildTypesAiobotocorePackage "forecastquery" "2.11.2" "sha256-Sne3DwWkPz0CqmOlbxLcR9ooSW4soLSuNPNfs9L9pAo=";

  types-aiobotocore-frauddetector = buildTypesAiobotocorePackage "frauddetector" "2.11.2" "sha256-zQ50MEleTedxViEOOs2u5GJSs36zRw7crvMA3h7FLZU=";

  types-aiobotocore-fsx = buildTypesAiobotocorePackage "fsx" "2.11.2" "sha256-VTjXUrEzhGuT2YjeTdY4IKxa/DxNmfnPEnZ7vQoAzKA=";

  types-aiobotocore-gamelift = buildTypesAiobotocorePackage "gamelift" "2.11.2" "sha256-AgZvipboBZnhSlC7K0JRFpH8Z4pNPT2UfdXYjshxF8Y=";

  types-aiobotocore-gamesparks = buildTypesAiobotocorePackage "gamesparks" "2.6.0" "sha256-9iV7bpGMnzz9TH+g1YpPjbKBSKY3rcL/OJvMOzwLC1M=";

  types-aiobotocore-glacier = buildTypesAiobotocorePackage "glacier" "2.11.2" "sha256-qDj9RSbqHPpJ5yU+AXPeA+umbbSrf2Ssu1g0aiLvnMw=";

  types-aiobotocore-globalaccelerator = buildTypesAiobotocorePackage "globalaccelerator" "2.11.2" "sha256-Ef+Ujeoc7gSrtjNbPEd4Y1F1eP4c4WKwRBIbbiCe/d8=";

  types-aiobotocore-glue = buildTypesAiobotocorePackage "glue" "2.11.2" "sha256-CvNGo1MNUf4GONCR8cISV8eC/ZcTeI1hgqb5WB+aZnI=";

  types-aiobotocore-grafana = buildTypesAiobotocorePackage "grafana" "2.11.2" "sha256-Nv4t50tCoOFp7GhVhNkUldUyQsTj7aY0QnfXzIl0BfY=";

  types-aiobotocore-greengrass = buildTypesAiobotocorePackage "greengrass" "2.11.2" "sha256-FvrpT2aOOD93rSy3c8VoUQAt9q0pgvoL1PaBccSCw00=";

  types-aiobotocore-greengrassv2 = buildTypesAiobotocorePackage "greengrassv2" "2.11.2" "sha256-x9x7Hmrm6XTDrFKT2ZmMy3kaRFAu22TEe3Miv2F6H0g=";

  types-aiobotocore-groundstation = buildTypesAiobotocorePackage "groundstation" "2.11.2" "sha256-eds5ZF/JpTaZyEg91RkID5sjy6gBVnixvNOUkO/gStU=";

  types-aiobotocore-guardduty = buildTypesAiobotocorePackage "guardduty" "2.11.2" "sha256-zj0sU8OWIFHKD/A4fbGytLeNQhyfdEg/ANSfM74ySrk=";

  types-aiobotocore-health = buildTypesAiobotocorePackage "health" "2.11.2" "sha256-r+oyRLvZP0H5UOmW0UK9qRNDLCPhvsUQrsO2DGA01Lk=";

  types-aiobotocore-healthlake = buildTypesAiobotocorePackage "healthlake" "2.11.2" "sha256-gg4maW0abnPj+1+qJCykrjdS0c7Lb71H3zhQPMltZcQ=";

  types-aiobotocore-honeycode = buildTypesAiobotocorePackage "honeycode" "2.11.2" "sha256-h+Mi42MOl8GHLdVJUu024Y5ICtQcHVY6odyxH/eAl1g=";

  types-aiobotocore-iam = buildTypesAiobotocorePackage "iam" "2.11.2" "sha256-fXk5xj6lJPosnlUBTcPM0dwYv+TEf2OeXcZQEKrK2cY=";

  types-aiobotocore-identitystore = buildTypesAiobotocorePackage "identitystore" "2.11.2" "sha256-T/91ZTr/RsNj2WcwvlC8QVbglJgH3yu0hTDh0kb3Euk=";

  types-aiobotocore-imagebuilder = buildTypesAiobotocorePackage "imagebuilder" "2.11.2" "sha256-tZHFF9JmYUJ+0mFXuWBHNfi+kEhi46J3jjTnA17B9V0=";

  types-aiobotocore-importexport = buildTypesAiobotocorePackage "importexport" "2.11.2" "sha256-E2Roi3zEeim9R0fXXwgi+bEB9bDBC2Eev2lI/6Lfrmw=";

  types-aiobotocore-inspector = buildTypesAiobotocorePackage "inspector" "2.11.2" "sha256-Isl+sNzDxiv3sTuBkL8MkcaZW1yB8O6j7kTXGPgcHW4=";

  types-aiobotocore-inspector2 = buildTypesAiobotocorePackage "inspector2" "2.11.2" "sha256-Nq2mUWIzziku4bcyjZQA9/luP8q0tyGOkNdHr1Rem80=";

  types-aiobotocore-internetmonitor = buildTypesAiobotocorePackage "internetmonitor" "2.11.2" "sha256-g8CL+bL2P4STnx6937WNozQ1QL2EWjCMrTjS+jYTPCI=";

  types-aiobotocore-iot = buildTypesAiobotocorePackage "iot" "2.11.2" "sha256-QKhDQUOfoFJTzJn5cG8USV2503MzPHE5jFlHqMKhn/A=";

  types-aiobotocore-iot-data = buildTypesAiobotocorePackage "iot-data" "2.11.2" "sha256-+UFQoQI1ZHQHryki1SZi6SRyEQHImAxmFsL9MHuY+Hk=";

  types-aiobotocore-iot-jobs-data = buildTypesAiobotocorePackage "iot-jobs-data" "2.11.2" "sha256-ZZyQXut8dYT2uTYrrugoHd4DPNDHz53uCbIcUc1ibD8=";

  types-aiobotocore-iot-roborunner = buildTypesAiobotocorePackage "iot-roborunner" "2.11.2" "sha256-65n/QRMNxmXysRtdQajwAN2yX00MpcM6045M65k3fQ8=";

  types-aiobotocore-iot1click-devices = buildTypesAiobotocorePackage "iot1click-devices" "2.11.2" "sha256-n01JfOuAJa1M1lxV/IjM1w7kws8UpfI5/Wx5jxqrB9w=";

  types-aiobotocore-iot1click-projects = buildTypesAiobotocorePackage "iot1click-projects" "2.11.2" "sha256-8pX6X71farX+IXR/LSfEU1LNul2/T7qCnAXwsuGBZI4=";

  types-aiobotocore-iotanalytics = buildTypesAiobotocorePackage "iotanalytics" "2.11.2" "sha256-JAUUApgPoSlv8ZJY+WX3+Aetey7SXIpqxWs3gbrgW3c=";

  types-aiobotocore-iotdeviceadvisor = buildTypesAiobotocorePackage "iotdeviceadvisor" "2.11.2" "sha256-AieTPU2zw4m7cFITd3udE03Yq/wlZFuwOCVb9vy83vk=";

  types-aiobotocore-iotevents = buildTypesAiobotocorePackage "iotevents" "2.11.2" "sha256-kLODxMyHr7oo9LruKVl2ncg5Fi8GkSEfKoe2VqmbEeI=";

  types-aiobotocore-iotevents-data = buildTypesAiobotocorePackage "iotevents-data" "2.11.2" "sha256-uVsWsZy8xAISqNpPN7qctpxhfkaS4XXshG+iCpSqi58=";

  types-aiobotocore-iotfleethub = buildTypesAiobotocorePackage "iotfleethub" "2.11.2" "sha256-+mmy4nqLxHuQ1xxgztft0g3uyoNXd56C6wwL7aQ2ono=";

  types-aiobotocore-iotfleetwise = buildTypesAiobotocorePackage "iotfleetwise" "2.11.2" "sha256-57fg4yeNePHkyvFN1rrGn0zh576dPAFkqroSm+Tp7Tc=";

  types-aiobotocore-iotsecuretunneling = buildTypesAiobotocorePackage "iotsecuretunneling" "2.11.2" "sha256-hvJs4KzaTK2ougi16IrVhD9kHnHl7HN4xLhUqVcDNQg=";

  types-aiobotocore-iotsitewise = buildTypesAiobotocorePackage "iotsitewise" "2.11.2" "sha256-qOfVU9YH1xYLORFeeSBAE8biTHvpiBcgzvvQXZYvtmI=";

  types-aiobotocore-iotthingsgraph = buildTypesAiobotocorePackage "iotthingsgraph" "2.11.2" "sha256-XrLIkbqPoCOch+J8Gt9z4JP+4tyA7qkcqDMv+lF4Qe8=";

  types-aiobotocore-iottwinmaker = buildTypesAiobotocorePackage "iottwinmaker" "2.11.2" "sha256-+C/oOZEJ/qqu3YhDgrr8evDEBN63QAT6P6nes3T7sSI=";

  types-aiobotocore-iotwireless = buildTypesAiobotocorePackage "iotwireless" "2.11.2" "sha256-BTvtuBIj05XJLe2XXkxeZbddmevzXAoxylfpEE0L3PY=";

  types-aiobotocore-ivs = buildTypesAiobotocorePackage "ivs" "2.11.2" "sha256-dxovawH56iI3UmWpUTPl3utJOp1XGYk6AVGTTq03Aa4=";

  types-aiobotocore-ivs-realtime = buildTypesAiobotocorePackage "ivs-realtime" "2.11.2" "sha256-hYrdXBE0DQy0k0TM0WpuxSIvmnq5dF2nyy+RHt7q5QM=";

  types-aiobotocore-ivschat = buildTypesAiobotocorePackage "ivschat" "2.11.2" "sha256-yRPTeOjvFUaU0Pt4IydYSHNZvf4egj0jNj9uF9Z3s3w=";

  types-aiobotocore-kafka = buildTypesAiobotocorePackage "kafka" "2.11.2" "sha256-qcNqcSME1ihk5i0cjoe4XsEiM9oafjYNaESU8zxaNp8=";

  types-aiobotocore-kafkaconnect = buildTypesAiobotocorePackage "kafkaconnect" "2.11.2" "sha256-gkPedqkyaElW78yq7xC0Afswcs2SAiAPgKuFMOqpr+A=";

  types-aiobotocore-kendra = buildTypesAiobotocorePackage "kendra" "2.11.2" "sha256-2Gqu/wamqCf8r7XQjMotNVesvlQQKFY+v2qhFGEq7Bs=";

  types-aiobotocore-kendra-ranking = buildTypesAiobotocorePackage "kendra-ranking" "2.11.2" "sha256-TVhSsL/6ZZImHdwIi66UsS6WxnDb1ZSJO09QdZiazbI=";

  types-aiobotocore-keyspaces = buildTypesAiobotocorePackage "keyspaces" "2.11.2" "sha256-VTi7r0qB1O4zaS/VnZ+dItsOLbvZytEhzYO6yO5WoQg=";

  types-aiobotocore-kinesis = buildTypesAiobotocorePackage "kinesis" "2.11.2" "sha256-yybY1DIO68QDlsFwly6tvdf7FfFTIVWYgSKYVfL2jxw=";

  types-aiobotocore-kinesis-video-archived-media = buildTypesAiobotocorePackage "kinesis-video-archived-media" "2.11.2" "sha256-RV9DyGgCrTfP0f6MxJFyqzWlKDqyewB3M/EM/m9og/Q=";

  types-aiobotocore-kinesis-video-media = buildTypesAiobotocorePackage "kinesis-video-media" "2.11.2" "sha256-lV6aNCvVNULd5foNDHpIdR+9XshDlDPtM3YN4P0c4Q4=";

  types-aiobotocore-kinesis-video-signaling = buildTypesAiobotocorePackage "kinesis-video-signaling" "2.11.2" "sha256-KsKInDsGfipueDGMmPmQKoeG6DYK8e9FpgrrO7pPwNY=";

  types-aiobotocore-kinesis-video-webrtc-storage = buildTypesAiobotocorePackage "kinesis-video-webrtc-storage" "2.11.2" "sha256-B3V1ho4oPas9UD6YCDpUl3if69dJlTRSxSLzHPa6Ias=";

  types-aiobotocore-kinesisanalytics = buildTypesAiobotocorePackage "kinesisanalytics" "2.11.2" "sha256-32uEJswxpS4CptKIV7vBZD6DjzlSuhptNfULE9Fcikk=";

  types-aiobotocore-kinesisanalyticsv2 = buildTypesAiobotocorePackage "kinesisanalyticsv2" "2.11.2" "sha256-R/s7CD1hAlNsvmMe7PCzZL9xIV8O21lZgMXtzqib0IQ=";

  types-aiobotocore-kinesisvideo = buildTypesAiobotocorePackage "kinesisvideo" "2.11.2" "sha256-nRRSzjYxQDFvfD4fuTWl+LfyPg5RoNHg8loGDxzVVrk=";

  types-aiobotocore-kms = buildTypesAiobotocorePackage "kms" "2.11.2" "sha256-e9y0ZjEzAr41xE2jSc5xCeftDK7EEg/SKqkgWkkMeRE=";

  types-aiobotocore-lakeformation = buildTypesAiobotocorePackage "lakeformation" "2.11.2" "sha256-XX3f+pw03ft13aRml7ublI72AjbVm8XlgcF4WLaT8UA=";

  types-aiobotocore-lambda = buildTypesAiobotocorePackage "lambda" "2.11.2" "sha256-b0QPtSWITrvIrQdpcFb7m5EEbgyyX1UaE36Ds2UzieY=";

  types-aiobotocore-lex-models = buildTypesAiobotocorePackage "lex-models" "2.11.2" "sha256-oLe70GFx6BJosKfgrFzde8G3gd3Tb9mLRKy45gx4s8U=";

  types-aiobotocore-lex-runtime = buildTypesAiobotocorePackage "lex-runtime" "2.11.2" "sha256-JfipFKHOk7w2iGmey0MxSGW1QFDdNY1ArptnNc4nR70=";

  types-aiobotocore-lexv2-models = buildTypesAiobotocorePackage "lexv2-models" "2.11.2" "sha256-sQ1liyCEjK8+QJYF5e3FFbPNWKfmGFV3QOv2lNZ4rR4=";

  types-aiobotocore-lexv2-runtime = buildTypesAiobotocorePackage "lexv2-runtime" "2.11.2" "sha256-LV9yyj5NsgRCSs+jQ2sNaEWuUKluLB00dtuKfzR+Cn0=";

  types-aiobotocore-license-manager = buildTypesAiobotocorePackage "license-manager" "2.11.2" "sha256-9mNtD4FE3PQ6DNAhH8IcVSmlP9iDgswweWJ6m9sSxLo=";

  types-aiobotocore-license-manager-linux-subscriptions = buildTypesAiobotocorePackage "license-manager-linux-subscriptions" "2.11.2" "sha256-DmYp2EEdSip+CNQw2mF27NftTcl/RCStoJUIUE98kZ4=";

  types-aiobotocore-license-manager-user-subscriptions = buildTypesAiobotocorePackage "license-manager-user-subscriptions" "2.11.2" "sha256-WWeTc1oPQc/BGve6ulckgoE6Un2VsEQO+jZ9Vn1YN1M=";

  types-aiobotocore-lightsail = buildTypesAiobotocorePackage "lightsail" "2.11.2" "sha256-o2DSZMBf7SUboQRa+j3w9XX97B1V+IrKe4lcYTTbKqU=";

  types-aiobotocore-location = buildTypesAiobotocorePackage "location" "2.11.2" "sha256-2qLEPAx24yVox+WzM1F+TgrMHUICh/u52CrIkan4jKw=";

  types-aiobotocore-logs = buildTypesAiobotocorePackage "logs" "2.11.2" "sha256-kMT5kfYjkuEOYqEGgJSPrT2zA0SRwR7ozROrK/auyWI=";

  types-aiobotocore-lookoutequipment = buildTypesAiobotocorePackage "lookoutequipment" "2.11.2" "sha256-tkgaimET3g+IYEPa07877wIkTRl6qg85ppcWttRunKU=";

  types-aiobotocore-lookoutmetrics = buildTypesAiobotocorePackage "lookoutmetrics" "2.11.2" "sha256-Ck43tu6SnKPtQW3+6WClcf8rLGF8jS7vg4N/VeeWcDM=";

  types-aiobotocore-lookoutvision = buildTypesAiobotocorePackage "lookoutvision" "2.11.2" "sha256-0MOrWtTHMUf4HPbM/Fi8JtWSD+UqXFg3zQNwFbhmydI=";

  types-aiobotocore-m2 = buildTypesAiobotocorePackage "m2" "2.11.2" "sha256-q3oYdCaMzvZ/FYkldC0DbzAHscuAGTq8WyAQwZlCNso=";

  types-aiobotocore-machinelearning = buildTypesAiobotocorePackage "machinelearning" "2.11.2" "sha256-CKCC7W5h6qKv3Zya/e+WcVoWdOtCqoWKRlJFHSTdxaI=";

  types-aiobotocore-macie = buildTypesAiobotocorePackage "macie" "2.6.0" "sha256-gbl7jEgjk4twoxGM+WRg4MZ/nkGg7btiPOsPptR7yfw=";

  types-aiobotocore-macie2 = buildTypesAiobotocorePackage "macie2" "2.11.2" "sha256-zg/QhW+4Chugyg6rG5HtrE1GAhbWUaveJpaJFemoN94=";

  types-aiobotocore-managedblockchain = buildTypesAiobotocorePackage "managedblockchain" "2.11.2" "sha256-jGl4I2voUUW0+OuEiqmB/MEHaMMlaaKHkKzod2r4d+E=";

  types-aiobotocore-managedblockchain-query = buildTypesAiobotocorePackage "managedblockchain-query" "2.11.2" "sha256-E0jvEhS96gCpV8uIUySP4EmxsFBnS8A4DOM0rOEtNHs=";

  types-aiobotocore-marketplace-catalog = buildTypesAiobotocorePackage "marketplace-catalog" "2.11.2" "sha256-ASsMuZQJlYkEFGwMByXHNlxyJVjjMWSkzOBG2l77AyA=";

  types-aiobotocore-marketplace-entitlement = buildTypesAiobotocorePackage "marketplace-entitlement" "2.11.2" "sha256-AxS9uLbEut6+4PLuLBB9ddb/6aPWCzBQBG2XyJW6VRA=";

  types-aiobotocore-marketplacecommerceanalytics = buildTypesAiobotocorePackage "marketplacecommerceanalytics" "2.11.2" "sha256-SgmAl7uy4YUqMwGWbt+vjjAhggfzzVXy14eZuowl8Q0=";

  types-aiobotocore-mediaconnect = buildTypesAiobotocorePackage "mediaconnect" "2.11.2" "sha256-P+HWJ/nEkeccqTNk8AotPjSXvHW2gahfhfI5hDeXnOs=";

  types-aiobotocore-mediaconvert = buildTypesAiobotocorePackage "mediaconvert" "2.11.2" "sha256-Umk+VdPTQSp4VmEqfCdDwU1coJaMU/+tGgi/bjgb0xw=";

  types-aiobotocore-medialive = buildTypesAiobotocorePackage "medialive" "2.11.2" "sha256-/afargcEN7hB5DajP4EL+juei59/rLQp+XKm1N9QEbA=";

  types-aiobotocore-mediapackage = buildTypesAiobotocorePackage "mediapackage" "2.11.2" "sha256-sAxc6wjEXz5zqq6iDatNbWH+cYQkP7RMMAgnTR35Hdg=";

  types-aiobotocore-mediapackage-vod = buildTypesAiobotocorePackage "mediapackage-vod" "2.11.2" "sha256-qjfONLIXIeXfZForb5PBEZBK1CpWAvkTMy2hqMJIZQA=";

  types-aiobotocore-mediapackagev2 = buildTypesAiobotocorePackage "mediapackagev2" "2.11.2" "sha256-QBDIxGZ4ZP4CN9VpV0UhE0PYWnF2L+FRk61qLfLNDj4=";

  types-aiobotocore-mediastore = buildTypesAiobotocorePackage "mediastore" "2.11.2" "sha256-jPWj2lyMNpEhJwWYosvYPA6g4b8RjHvLyCJ+545suKc=";

  types-aiobotocore-mediastore-data = buildTypesAiobotocorePackage "mediastore-data" "2.11.2" "sha256-dwEipFOs4xkkegGVtNysoTLsVfal7ysR2zAJ7ehXQYw=";

  types-aiobotocore-mediatailor = buildTypesAiobotocorePackage "mediatailor" "2.11.2" "sha256-LF9iBh/e3Ac54ampStAudt5cqbarnhWupRR1+A300xc=";

  types-aiobotocore-medical-imaging = buildTypesAiobotocorePackage "medical-imaging" "2.11.2" "sha256-aYViyNpTZ66Ow2Vymcqc/Fs6ESvl/U61eEpYmozaK+Q=";

  types-aiobotocore-memorydb = buildTypesAiobotocorePackage "memorydb" "2.11.2" "sha256-EcqRC07VonREJAnEQAuM0D6pewJd1wPpIHQh/oEGICg=";

  types-aiobotocore-meteringmarketplace = buildTypesAiobotocorePackage "meteringmarketplace" "2.11.2" "sha256-B7Ls8R45clgh2OnBfLtYV49pzwCKs+tGVUPa298U51A=";

  types-aiobotocore-mgh = buildTypesAiobotocorePackage "mgh" "2.11.2" "sha256-/6NysP2UP5gttr4CE0dr38ictulCYUnzbv/3owe/8Ww=";

  types-aiobotocore-mgn = buildTypesAiobotocorePackage "mgn" "2.11.2" "sha256-sOHVNzltGlxz4FZR0DVoGJVo6Ga8+UMW4owsaubVCPA=";

  types-aiobotocore-migration-hub-refactor-spaces = buildTypesAiobotocorePackage "migration-hub-refactor-spaces" "2.11.2" "sha256-A8aLuBH4xtvpOjlLTBy5iPHiub9P1plbZWjCGke/WzA=";

  types-aiobotocore-migrationhub-config = buildTypesAiobotocorePackage "migrationhub-config" "2.11.2" "sha256-spHl1upjr2r1a8DG5XBRnmaowpOYFtnpMLGtoEakwO8=";

  types-aiobotocore-migrationhuborchestrator = buildTypesAiobotocorePackage "migrationhuborchestrator" "2.11.2" "sha256-SgIGw/aiY0VGJtVdmg/b5FZhmhaSqUHJ4/BfqShnRDo=";

  types-aiobotocore-migrationhubstrategy = buildTypesAiobotocorePackage "migrationhubstrategy" "2.11.2" "sha256-DhuUTGNVKB0jHd+MJ3valcCQSL5sKJlMtUP56aVqkkk=";

  types-aiobotocore-mobile = buildTypesAiobotocorePackage "mobile" "2.11.2" "sha256-fJp9LXYqauvrxIa6i0208JRm3CuTpzV4rvYmYTXH7os=";

  types-aiobotocore-mq = buildTypesAiobotocorePackage "mq" "2.11.2" "sha256-UtnqvuB42ZdW9Pl4dKDC8Y+OfXe1pULa2TGWPh2BvDM=";

  types-aiobotocore-mturk = buildTypesAiobotocorePackage "mturk" "2.11.2" "sha256-6+O/r6fNyT1jm/3088WnUmy/lLeoSUp3XzhvhqbD9Yo=";

  types-aiobotocore-mwaa = buildTypesAiobotocorePackage "mwaa" "2.11.2" "sha256-nnvnvNlI0d9eY6BK+fM0HK9+cBDStuwl11AlK5lRw8g=";

  types-aiobotocore-neptune = buildTypesAiobotocorePackage "neptune" "2.11.2" "sha256-1aFyIW+UZv6jxDRn8ry6gIrLMJbgaYKVKlkIOAGWRHE=";

  types-aiobotocore-network-firewall = buildTypesAiobotocorePackage "network-firewall" "2.11.2" "sha256-MhxCre5EDkm9EOtNdPLqTckeazZJcTmbZ2r8soQA+Jc=";

  types-aiobotocore-networkmanager = buildTypesAiobotocorePackage "networkmanager" "2.11.2" "sha256-6aVK9lzDYgLCqy0cwp0ORJn0BT9cSk4NEJayxOjF7ZI=";

  types-aiobotocore-nimble = buildTypesAiobotocorePackage "nimble" "2.11.2" "sha256-QbM+B7Tfvcs/ve35QzymZKVnWhtB7oFiwI6lloQLxVY=";

  types-aiobotocore-oam = buildTypesAiobotocorePackage "oam" "2.11.2" "sha256-lVM/HoERd7xawMrVIzHYUDnc+qymMSloqcFRh+u7mjU=";

  types-aiobotocore-omics = buildTypesAiobotocorePackage "omics" "2.11.2" "sha256-r81zJzAsRFSpJRkZwWvN5hYj0S/JEuUFuCrNJO8kwlc=";

  types-aiobotocore-opensearch = buildTypesAiobotocorePackage "opensearch" "2.11.2" "sha256-zFrWBgOmagE6CtdQfSOZTgoKAJHmCsa0tcOrGbO6T60=";

  types-aiobotocore-opensearchserverless = buildTypesAiobotocorePackage "opensearchserverless" "2.11.2" "sha256-JrtkoMlkuM9KiJMWRxTyFw/9usEjOO2Z1qYc4SsDOtM=";

  types-aiobotocore-opsworks = buildTypesAiobotocorePackage "opsworks" "2.11.2" "sha256-z7kEjYPPi5CQ/cWIm06bOuwCf/0lU7/9Wv6FK5TxIDk=";

  types-aiobotocore-opsworkscm = buildTypesAiobotocorePackage "opsworkscm" "2.11.2" "sha256-34u790+vU+yqsAFh2P0lV6zASqCAl776l8a+a9iVucw=";

  types-aiobotocore-organizations = buildTypesAiobotocorePackage "organizations" "2.11.2" "sha256-coo7Pv1DaAh+d1594EK+kQV+Fm423zIYaotG+Te8JN8=";

  types-aiobotocore-osis = buildTypesAiobotocorePackage "osis" "2.11.2" "sha256-1pqghG7TZeT7FwT8nCQfQnKpiKgovfv4zpjAAgYnxeM=";

  types-aiobotocore-outposts = buildTypesAiobotocorePackage "outposts" "2.11.2" "sha256-Rcz9n5/L5B/BPiUiJp2rsqfElU6o6n24d/ja+w+n1aY=";

  types-aiobotocore-panorama = buildTypesAiobotocorePackage "panorama" "2.11.2" "sha256-P3HlDSCLDzmdq9bEvcM0c7YDdZu0S6smXJejCkjSvF8=";

  types-aiobotocore-payment-cryptography = buildTypesAiobotocorePackage "payment-cryptography" "2.11.2" "sha256-tHh5VCmz7dE5dOQPwQtwF1yrG7iPLO3LJCEXcxi1N4M=";

  types-aiobotocore-payment-cryptography-data = buildTypesAiobotocorePackage "payment-cryptography-data" "2.11.2" "sha256-opL4WsHUD7VSMrFguX7LKD8rzuncTMnn9KU45AgYoKk=";

  types-aiobotocore-personalize = buildTypesAiobotocorePackage "personalize" "2.11.2" "sha256-yv6GvZxxzKoquIqE3lu/xpfYxB9QvKEipmKk4YM2jec=";

  types-aiobotocore-personalize-events = buildTypesAiobotocorePackage "personalize-events" "2.11.2" "sha256-Dc6z1uAWiVPyiN0ecX4br07bKdojmeo0MC7c3re1hyM=";

  types-aiobotocore-personalize-runtime = buildTypesAiobotocorePackage "personalize-runtime" "2.11.2" "sha256-niY0fPGHHWpAPOffgjEWRttS43Kw4uxkcTy5xEmaPPc=";

  types-aiobotocore-pi = buildTypesAiobotocorePackage "pi" "2.11.2" "sha256-I79oOBYzQ35mrD9ZkwZo9yFKkvOVg5MHg1/qsWBs1hA=";

  types-aiobotocore-pinpoint = buildTypesAiobotocorePackage "pinpoint" "2.11.2" "sha256-Id0RR3EWaGZIMMaA1CSKwtX4hPQNvYIo04lCjzGbLno=";

  types-aiobotocore-pinpoint-email = buildTypesAiobotocorePackage "pinpoint-email" "2.11.2" "sha256-TDRjuFHP/6MSNUwO0q9mgxXw4GAjYeEAEwcGf0a+q3U=";

  types-aiobotocore-pinpoint-sms-voice = buildTypesAiobotocorePackage "pinpoint-sms-voice" "2.11.2" "sha256-GUDNq34JKrR6F1uzGvrINNEvZf75c6hrtcVJ4ishQ1E=";

  types-aiobotocore-pinpoint-sms-voice-v2 = buildTypesAiobotocorePackage "pinpoint-sms-voice-v2" "2.11.2" "sha256-P59HWAaJrCKpwyY6kdyd4XHHRhmd2DxafY5Ytu5d8Ow=";

  types-aiobotocore-pipes = buildTypesAiobotocorePackage "pipes" "2.11.2" "sha256-BBZWoO4sWWSSJOf1MnMF9KrtGKTc+h8yuIjlnx0iIBE=";

  types-aiobotocore-polly = buildTypesAiobotocorePackage "polly" "2.11.2" "sha256-CrNLX+1TDawkCrBgmNqUbhJcbh208sKpfbSpS6dksPY=";

  types-aiobotocore-pricing = buildTypesAiobotocorePackage "pricing" "2.11.2" "sha256-sbiwfFkB6GDwkw38mTbKFis7SOYcM7lrC/sOzjCHi0A=";

  types-aiobotocore-privatenetworks = buildTypesAiobotocorePackage "privatenetworks" "2.11.2" "sha256-fHGSVacmVC4/mOaeiMhgJwcMz+x7njlFm8EesZnxdd0=";

  types-aiobotocore-proton = buildTypesAiobotocorePackage "proton" "2.11.2" "sha256-4OlzYFr/xz603R6am4Mk4A2C/cGXOksSdxopm/2rhV4=";

  types-aiobotocore-qldb = buildTypesAiobotocorePackage "qldb" "2.11.2" "sha256-4CvtgQH4KoYEUWzCYD/3aC1Ouo0XiOL8ByKCdFD+DPQ=";

  types-aiobotocore-qldb-session = buildTypesAiobotocorePackage "qldb-session" "2.11.2" "sha256-ccTKJjTvCtPiK0Z+TLxFYOE+/zpLjkBaEcT7EtPw5IM=";

  types-aiobotocore-quicksight = buildTypesAiobotocorePackage "quicksight" "2.11.2" "sha256-Len2Z6UxFRlt4lzyNB7bMw3SO+mRqgBO5YHaz9N/4V4=";

  types-aiobotocore-ram = buildTypesAiobotocorePackage "ram" "2.11.2" "sha256-CcMrlDc5sbbjK0NLOQB7+Y7qaODQWz1NTIB6yYZB7OE=";

  types-aiobotocore-rbin = buildTypesAiobotocorePackage "rbin" "2.11.2" "sha256-/dvoqri/C9QzCddypXJXJYrhQCVHSn3S45VJBHeS+5k=";

  types-aiobotocore-rds = buildTypesAiobotocorePackage "rds" "2.11.2" "sha256-qBj2alCz0Us1vUIlstWa++ePJgO7xYeE16Hlq2JRx1Q=";

  types-aiobotocore-rds-data = buildTypesAiobotocorePackage "rds-data" "2.11.2" "sha256-Om3guoTpVeL7dvRt7D3p8B8ZkWjb3waQAeM89e0rpUQ=";

  types-aiobotocore-redshift = buildTypesAiobotocorePackage "redshift" "2.11.2" "sha256-b4hNZ77+lFUmFLqhowH/bOn4kSCuqvIxU18vj7jcFHI=";

  types-aiobotocore-redshift-data = buildTypesAiobotocorePackage "redshift-data" "2.11.2" "sha256-J96w8/9UdtRzbcWqw4E0S/FrknEKnTTxOm59Tcu2jvM=";

  types-aiobotocore-redshift-serverless = buildTypesAiobotocorePackage "redshift-serverless" "2.11.2" "sha256-XdoXh+IE82wywcCDY1bA5tr8dJbSNvXB5gIY9nLoPWo=";

  types-aiobotocore-rekognition = buildTypesAiobotocorePackage "rekognition" "2.11.2" "sha256-0ODtTavUgRNXUzK7bjVa86lYNoCn+iH64QAJN1cvc84=";

  types-aiobotocore-resiliencehub = buildTypesAiobotocorePackage "resiliencehub" "2.11.2" "sha256-abgoq7erXikE8KNMdRBdItI0/Kzapgg0BcDVjRbjBYU=";

  types-aiobotocore-resource-explorer-2 = buildTypesAiobotocorePackage "resource-explorer-2" "2.11.2" "sha256-xXj60XZQMUiHXETJGQjvpzd+I6A3isV6KLOz3d5qpto=";

  types-aiobotocore-resource-groups = buildTypesAiobotocorePackage "resource-groups" "2.11.2" "sha256-lw4MR2UKLdWQhpaeMnu1/q6bZMF7sPenQfeErKfWGxM=";

  types-aiobotocore-resourcegroupstaggingapi = buildTypesAiobotocorePackage "resourcegroupstaggingapi" "2.11.2" "sha256-QpVVzSgMUTww9Llo1WG6mn4BruNDStXhy6kNoPZR3s8=";

  types-aiobotocore-robomaker = buildTypesAiobotocorePackage "robomaker" "2.11.2" "sha256-RWKmf8SArQUMNYGF7e7dmYMkQIlpxuzKdZis4w/cKpg=";

  types-aiobotocore-rolesanywhere = buildTypesAiobotocorePackage "rolesanywhere" "2.11.2" "sha256-M2FfcvPJenYY/WD8iH9foiVIRsFG9WKsMLOuPUnjs/U=";

  types-aiobotocore-route53 = buildTypesAiobotocorePackage "route53" "2.11.2" "sha256-wes4LEtLv5ybE51iXxHQg18qCAm5sZ+vZGiXj8bK3yk=";

  types-aiobotocore-route53-recovery-cluster = buildTypesAiobotocorePackage "route53-recovery-cluster" "2.11.2" "sha256-xcGxuzmb8ZG56tp352OVDRn81EjSjPySxDhcg/n0B3A=";

  types-aiobotocore-route53-recovery-control-config = buildTypesAiobotocorePackage "route53-recovery-control-config" "2.11.2" "sha256-z7IdwFRh8yaTv/1BMUdCOmUueSIilBB201OCiAFe+Kw=";

  types-aiobotocore-route53-recovery-readiness = buildTypesAiobotocorePackage "route53-recovery-readiness" "2.11.2" "sha256-W1q61V0sPYF1XD109kf1uKgOLggvTEtbtDA7xaWDFB0=";

  types-aiobotocore-route53domains = buildTypesAiobotocorePackage "route53domains" "2.11.2" "sha256-xeuBRVcg+Fn8/lYTOZA3Le7LbpB9jrCCB2H8nQIq+4A=";

  types-aiobotocore-route53resolver = buildTypesAiobotocorePackage "route53resolver" "2.11.2" "sha256-yn0pE63A8Pzgx3NhSVKqlTFIgKFMklw+XWHTxKybwc4=";

  types-aiobotocore-rum = buildTypesAiobotocorePackage "rum" "2.11.2" "sha256-uxY9FB+BVi7aC7reo2FsNEELX2bdgg+/IY6qxUz7U8c=";

  types-aiobotocore-s3 = buildTypesAiobotocorePackage "s3" "2.11.2" "sha256-n2hn56rUVBuS5qNep7junV5LGZWGLdBt4EVkSORg02s=";

  types-aiobotocore-s3control = buildTypesAiobotocorePackage "s3control" "2.11.2" "sha256-PNo0W4KDRwUyzg+aSxoocYPqllG4cMAB5SEsj5mt3lk=";

  types-aiobotocore-s3outposts = buildTypesAiobotocorePackage "s3outposts" "2.11.2" "sha256-hhqdwUHmEAPGQuPnhLJtDdHaIYb/sv/U6UCEg+CKkyA=";

  types-aiobotocore-sagemaker = buildTypesAiobotocorePackage "sagemaker" "2.11.2" "sha256-O9TbCPu6aHsK0NAmYVCZjy4G71EhlgzX24behEGU7eI=";

  types-aiobotocore-sagemaker-a2i-runtime = buildTypesAiobotocorePackage "sagemaker-a2i-runtime" "2.11.2" "sha256-N1RAqfBhqqw4q8G8xJPlSQ69ww7Vaz3ySafwi2oBrB8=";

  types-aiobotocore-sagemaker-edge = buildTypesAiobotocorePackage "sagemaker-edge" "2.11.2" "sha256-dHZZF5L+bVPDYFLXWHxSJjNAfKus2E2sUQlOXLp0TPk=";

  types-aiobotocore-sagemaker-featurestore-runtime = buildTypesAiobotocorePackage "sagemaker-featurestore-runtime" "2.11.2" "sha256-nTfFkbwnKM2flJfCIU+An2eDDrMkyjrayJ7V1zAFVoE=";

  types-aiobotocore-sagemaker-geospatial = buildTypesAiobotocorePackage "sagemaker-geospatial" "2.11.2" "sha256-8LYpcjMnPEOX7qbQ6I8zbs3/UoIhKEnvNC5qasqsqcc=";

  types-aiobotocore-sagemaker-metrics = buildTypesAiobotocorePackage "sagemaker-metrics" "2.11.2" "sha256-WM2MksGubVpLG73vK107MUh7tJcvBr0hiZ/669yPOq0=";

  types-aiobotocore-sagemaker-runtime = buildTypesAiobotocorePackage "sagemaker-runtime" "2.11.2" "sha256-/xKAA15x8xpMCh7kOi4kWuwaXulLRpMcnyzVPMH+Gh8=";

  types-aiobotocore-savingsplans = buildTypesAiobotocorePackage "savingsplans" "2.11.2" "sha256-he01wy13rhnE2xzXkJ3twOZsnQ/XfzMG74QP9Nyuj1o=";

  types-aiobotocore-scheduler = buildTypesAiobotocorePackage "scheduler" "2.11.2" "sha256-U2zesi+tt47KzbpdI94/S3ypcUUSWFUZNQRUcHRHWWY=";

  types-aiobotocore-schemas = buildTypesAiobotocorePackage "schemas" "2.11.2" "sha256-o+l4pAMZDwmVFnpArvKHNRB6zUC/AYWqrRsNZBgrV7Y=";

  types-aiobotocore-sdb = buildTypesAiobotocorePackage "sdb" "2.11.2" "sha256-IX8mZcFKSvfgCI+iXq6hByFwPBRRL8rqxr42XgPXZ8c=";

  types-aiobotocore-secretsmanager = buildTypesAiobotocorePackage "secretsmanager" "2.11.2" "sha256-Op15jR7QepqLkWxFG7dMrre904OC3N9viwzChS2bNno=";

  types-aiobotocore-securityhub = buildTypesAiobotocorePackage "securityhub" "2.11.2" "sha256-Rgc7+yij/CyhxOK/2hOQIVzrLW4lmRa+0eGxlWiIf38=";

  types-aiobotocore-securitylake = buildTypesAiobotocorePackage "securitylake" "2.11.2" "sha256-Hv6L2fWR7dHjhU3Oqm/sI18a/12DYJzPsCcGKlXCm80=";

  types-aiobotocore-serverlessrepo = buildTypesAiobotocorePackage "serverlessrepo" "2.11.2" "sha256-k4Xsag9IM9/kyv7TM9EH360yTC9mChJgxLS5U8MHRA8=";

  types-aiobotocore-service-quotas = buildTypesAiobotocorePackage "service-quotas" "2.11.2" "sha256-8XfZoANc59/sIqKsSMjvk8T41/BW8xX17ACjf1pXxyA=";

  types-aiobotocore-servicecatalog = buildTypesAiobotocorePackage "servicecatalog" "2.11.2" "sha256-7sLVYb2ZzdiVsqUOytiPt/b8GiW9qA2un4n2LORy4gY=";

  types-aiobotocore-servicecatalog-appregistry = buildTypesAiobotocorePackage "servicecatalog-appregistry" "2.11.2" "sha256-k5jGzYtjbnV/ZaJMQE/lbgmhYxF5k9Quk7/QaTJDjrw=";

  types-aiobotocore-servicediscovery = buildTypesAiobotocorePackage "servicediscovery" "2.11.2" "sha256-mJdB9fehiTA35dA766QlQyTkrvS4J4s8pCBq3cJcsxw=";

  types-aiobotocore-ses = buildTypesAiobotocorePackage "ses" "2.11.2" "sha256-iMgv2U0XPdil6xt4/3j1ZZGJGylEz8qDYzzvTP4N6n4=";

  types-aiobotocore-sesv2 = buildTypesAiobotocorePackage "sesv2" "2.11.2" "sha256-2eN+bo1BWU63a6xCexpVCZvblcCRdPlGf35D8v6A3Xg=";

  types-aiobotocore-shield = buildTypesAiobotocorePackage "shield" "2.11.2" "sha256-i5WHQ5wHvYdNpNJZWgAWAAD6mZPl/RPEOSh66l7PSCA=";

  types-aiobotocore-signer = buildTypesAiobotocorePackage "signer" "2.11.2" "sha256-v1FG59Mjxefyp4PpeLGfgHlrzVrUGUquqBSyxEM1OiU=";

  types-aiobotocore-simspaceweaver = buildTypesAiobotocorePackage "simspaceweaver" "2.11.2" "sha256-7UnTnGGGAfpPmU+m91R2n9AZinLoPFY/nqAjopnwhiU=";

  types-aiobotocore-sms = buildTypesAiobotocorePackage "sms" "2.11.2" "sha256-s/DbyfwPZ0qNvYaMWxuAwF9HqKihUjELdKPJ71DB1C4=";

  types-aiobotocore-sms-voice = buildTypesAiobotocorePackage "sms-voice" "2.11.2" "sha256-k0ujcxl1uupuVNDXDc53WTb3buAHziPHDG662LrP36s=";

  types-aiobotocore-snow-device-management = buildTypesAiobotocorePackage "snow-device-management" "2.11.2" "sha256-jCEaxTTobMmZBNAFauI0Oh0/gvhJZXyrbgvsIofmrKY=";

  types-aiobotocore-snowball = buildTypesAiobotocorePackage "snowball" "2.11.2" "sha256-f5RZLaBzcikIZ77Ei1JZZQuaKy2M+RkRpeNhsswSunU=";

  types-aiobotocore-sns = buildTypesAiobotocorePackage "sns" "2.11.2" "sha256-bja/dcxw3OOeCfFgpHK+6gnivYoqAzmqt2IetHLgzws=";

  types-aiobotocore-sqs = buildTypesAiobotocorePackage "sqs" "2.11.2" "sha256-9fVYF2qfjM5DYWZG2hbeg/XPz+K8tyGhzSxY8eW0mHI=";

  types-aiobotocore-ssm = buildTypesAiobotocorePackage "ssm" "2.11.2" "sha256-yztJVMvlWsZu9L+GzxTPdM2lzTKTW36T1OX0WmHgoBA=";

  types-aiobotocore-ssm-contacts = buildTypesAiobotocorePackage "ssm-contacts" "2.11.2" "sha256-0o9kuyEE7rzzgA4Q75udMRUADKbW+rLgmvIGCVJpJhA=";

  types-aiobotocore-ssm-incidents = buildTypesAiobotocorePackage "ssm-incidents" "2.11.2" "sha256-89yICjzgxAlJ+ljpfRsCwf4RITWX9y+alCdtTBeLhkw=";

  types-aiobotocore-ssm-sap = buildTypesAiobotocorePackage "ssm-sap" "2.11.2" "sha256-slJsfHBHVv+vPSfqNu/C9zl45SDX5H7K9rn+YVCca5Q=";

  types-aiobotocore-sso = buildTypesAiobotocorePackage "sso" "2.11.2" "sha256-ZAbFyBaGfQIRoMQkvnbViwShuvtIgTPmGZjScm1F7Bw=";

  types-aiobotocore-sso-admin = buildTypesAiobotocorePackage "sso-admin" "2.11.2" "sha256-DUOiPjmvmUL498QOrn4GBhnEw2GcFrOaj6YW5rh5i3M=";

  types-aiobotocore-sso-oidc = buildTypesAiobotocorePackage "sso-oidc" "2.11.2" "sha256-RmyyuORVrE0Qwl8yna/JlOXIrHYtyBVJPVpU2g0DDxY=";

  types-aiobotocore-stepfunctions = buildTypesAiobotocorePackage "stepfunctions" "2.11.2" "sha256-+w4WT5xRSShrvyKI9LpZlnBWwk52XZDM8EIx20DPfxk=";

  types-aiobotocore-storagegateway = buildTypesAiobotocorePackage "storagegateway" "2.11.2" "sha256-H3tINfz/GO514kayygBZ8ucyeEDfCUxObyqqKJFDIrs=";

  types-aiobotocore-sts = buildTypesAiobotocorePackage "sts" "2.11.2" "sha256-uzhkXmUdnXzHRTyUj+l6pskEJJGG/rSUtnK3GML7nCk=";

  types-aiobotocore-support = buildTypesAiobotocorePackage "support" "2.11.2" "sha256-i0rmU4YdFuZyuqyzFd2BCAKokXWMVVqOTN8Jm8cEvEc=";

  types-aiobotocore-support-app = buildTypesAiobotocorePackage "support-app" "2.11.2" "sha256-Duti4k7lA0jovcu8q+kv6HQWaMeZtKxN2wGScqNw+hc=";

  types-aiobotocore-swf = buildTypesAiobotocorePackage "swf" "2.11.2" "sha256-g29BPcFbEGwBs7qUKmJOBrhgcI7iGOglr3SJQ/HHe54=";

  types-aiobotocore-synthetics = buildTypesAiobotocorePackage "synthetics" "2.11.2" "sha256-h1FCzj5+IplgFJ0SpsY5okNURSpuC4zy4qAlhUyt7sE=";

  types-aiobotocore-textract = buildTypesAiobotocorePackage "textract" "2.11.2" "sha256-PzmzE1Mgka+bM2E4qwPS3N3lOz3ljYdI78KZ4flr6ac=";

  types-aiobotocore-timestream-query = buildTypesAiobotocorePackage "timestream-query" "2.11.2" "sha256-MK4YicO38uuJsHuEL6NZwh/qo6UANVK19sodjcJHNOs=";

  types-aiobotocore-timestream-write = buildTypesAiobotocorePackage "timestream-write" "2.11.2" "sha256-UBp0FEr4ufUQ2WvMEg1Rv1OgRdtzk6VoKJ56VHlcAyo=";

  types-aiobotocore-tnb = buildTypesAiobotocorePackage "tnb" "2.11.2" "sha256-ZnTjfCvcvshwPK0bBD/Ck6lGiy8+9T5cvFqPv2BnHOc=";

  types-aiobotocore-transcribe = buildTypesAiobotocorePackage "transcribe" "2.11.2" "sha256-GspypGik1nJBWksXZpID2uIP8zgiZnNidLC4uxWd4Uo=";

  types-aiobotocore-transfer = buildTypesAiobotocorePackage "transfer" "2.11.2" "sha256-wHO9PVHgTSDRiYbKxlkBCIhLB/gt1LtLWjXAG1eViEI=";

  types-aiobotocore-translate = buildTypesAiobotocorePackage "translate" "2.11.2" "sha256-I1b0qD9Trk6Dx2lKr8ERD4cQA+VKvBsmdCRJeIGEqhs=";

  types-aiobotocore-verifiedpermissions = buildTypesAiobotocorePackage "verifiedpermissions" "2.11.2" "sha256-JChel9RC22kon8uWBlJKMKuYuugbbsrZyjlrmg+fhgg=";

  types-aiobotocore-voice-id = buildTypesAiobotocorePackage "voice-id" "2.11.2" "sha256-RT09v7dqVet6tAb0IA5NfmzMy4IX2DAofcy729nZZwA=";

  types-aiobotocore-vpc-lattice = buildTypesAiobotocorePackage "vpc-lattice" "2.11.2" "sha256-Rlr0tzi20v4XosIPW9zkNqKWHN2rNd8DZGiiy1Nb5f0=";

  types-aiobotocore-waf = buildTypesAiobotocorePackage "waf" "2.11.2" "sha256-JnvB33lVkfViHtEDLo7r11dv5U9Kztv/OW+4gjGDB28=";

  types-aiobotocore-waf-regional = buildTypesAiobotocorePackage "waf-regional" "2.11.2" "sha256-Air8rMhqKgkO5TGqRojR+IYOnNXY+N7xNNqQPMn2jrc=";

  types-aiobotocore-wafv2 = buildTypesAiobotocorePackage "wafv2" "2.11.2" "sha256-b9S614sFcuX4E3W8EXz9Nbdx7sJmHfZz/6dyObuQV/w=";

  types-aiobotocore-wellarchitected = buildTypesAiobotocorePackage "wellarchitected" "2.11.2" "sha256-7HJ0WBfowqrWLwYvWgbDo+gftumeaepQSWpO5DqIJGE=";

  types-aiobotocore-wisdom = buildTypesAiobotocorePackage "wisdom" "2.11.2" "sha256-Kaz1XfeiPzKTeUPC2GxY1mr2Xfs2rMmk8qoJXsP+o6Q=";

  types-aiobotocore-workdocs = buildTypesAiobotocorePackage "workdocs" "2.11.2" "sha256-eSTETN2kjC/NgehPRXrSe+zZoFOS8Tuk+W51iT5iXt0=";

  types-aiobotocore-worklink = buildTypesAiobotocorePackage "worklink" "2.11.2" "sha256-0N9Va4wHn6SgCPBQ77VuHQgODlCaEgeoze+g//ZoQK8=";

  types-aiobotocore-workmail = buildTypesAiobotocorePackage "workmail" "2.11.2" "sha256-N/eiwpmwBimzDy4VT+m7nbe9PK2QlCa1+z3LKDjzZZI=";

  types-aiobotocore-workmailmessageflow = buildTypesAiobotocorePackage "workmailmessageflow" "2.11.2" "sha256-+M5VV+1wtSpDz7b7CtfIRIwJFpRA8GLdWRne+RQ2EGM=";

  types-aiobotocore-workspaces = buildTypesAiobotocorePackage "workspaces" "2.11.2" "sha256-JXslg9nlK/7VwSaVW6No0p0SxRLufoFhmhl+y6Lvsek=";

  types-aiobotocore-workspaces-web = buildTypesAiobotocorePackage "workspaces-web" "2.11.2" "sha256-Z4tueuOfvtxD6PrWk3Tfq/ztXcE3UZkVn8J6OLA49N4=";

  types-aiobotocore-xray = buildTypesAiobotocorePackage "xray" "2.11.2" "sha256-vw6nBEHHtmhHSM/gusdLGT+qB92USaycyIw4f9/bSNA=";
}
