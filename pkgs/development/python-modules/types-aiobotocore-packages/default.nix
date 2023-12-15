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

  types-aiobotocore-alexaforbusiness = buildTypesAiobotocorePackage "alexaforbusiness" "2.8.0" "sha256-rLWMVLKsvuyhBzVg0aI4lcw4ASz/nzVXnzCEWS3/3tY=";

  types-aiobotocore-amp = buildTypesAiobotocorePackage "amp" "2.8.0" "sha256-rLx9YbbysJ61FxKJgNbqPPFjUB2oT1B98p8nGPByyQc=";

  types-aiobotocore-amplify = buildTypesAiobotocorePackage "amplify" "2.8.0" "sha256-+hfKzZ21VBfv4zv8AWlKJIzw4k4mR8XjYUkmJW+dv+A=";

  types-aiobotocore-amplifybackend = buildTypesAiobotocorePackage "amplifybackend" "2.8.0" "sha256-4FdDQnj7h/WfOZ9V3Xwg7vCMfohyOl3Gb+bhauyBYqU=";

  types-aiobotocore-amplifyuibuilder = buildTypesAiobotocorePackage "amplifyuibuilder" "2.8.0" "sha256-KfyG5FI+P/5zO7D/qOocipzk4p2DFtzx4cXtNYP23gA=";

  types-aiobotocore-apigateway = buildTypesAiobotocorePackage "apigateway" "2.8.0" "sha256-NNgVburmRUEVgIAyGPUz+MX1vtS8fBuyen/jQiGKrKo=";

  types-aiobotocore-apigatewaymanagementapi = buildTypesAiobotocorePackage "apigatewaymanagementapi" "2.8.0" "sha256-Xh7PmcAqF/JC8x+29ZO+OWj0gaC3nJJZIJycnWez00A=";

  types-aiobotocore-apigatewayv2 = buildTypesAiobotocorePackage "apigatewayv2" "2.8.0" "sha256-u4074E+mZOxwGKkTDcWDEMooTYWpbqMoaRNRzOpFT5k=";

  types-aiobotocore-appconfig = buildTypesAiobotocorePackage "appconfig" "2.8.0" "sha256-F75m9QZZ8msaFdXW3K/DL2r4WTxLtqQkMmVWgmnMa/A=";

  types-aiobotocore-appconfigdata = buildTypesAiobotocorePackage "appconfigdata" "2.8.0" "sha256-P0nhXebQhixtvCaky/8NRBJpEa0mGh3VTLgmBMTtzUc=";

  types-aiobotocore-appfabric = buildTypesAiobotocorePackage "appfabric" "2.8.0" "sha256-BqugOZAUVA4I3MXJ4JXKYvnHghL99rxnNlvdc4yilMk=";

  types-aiobotocore-appflow = buildTypesAiobotocorePackage "appflow" "2.8.0" "sha256-Bl1RZc33s6ej5SWdpt1qAJkXzuuaYnSHN/VxnR9fU9I=";

  types-aiobotocore-appintegrations = buildTypesAiobotocorePackage "appintegrations" "2.8.0" "sha256-zetVe/ySSidCFpP+LSRoBEWjn/GAQIDjdgl+soYjAJY=";

  types-aiobotocore-application-autoscaling = buildTypesAiobotocorePackage "application-autoscaling" "2.8.0" "sha256-R1QCz40T9ZuVB7Hr4N1BpTtyRmkiTrXQIuE1QUPY3xQ=";

  types-aiobotocore-application-insights = buildTypesAiobotocorePackage "application-insights" "2.8.0" "sha256-0etunSEPkT6kmVP/ZkV9Ok+nF0lpzXrFeuUnabaqtOk=";

  types-aiobotocore-applicationcostprofiler = buildTypesAiobotocorePackage "applicationcostprofiler" "2.8.0" "sha256-EeAKZH/VNhmL5UZaJcM0euEXxaRr+tSxaIiNZDtmEtg=";

  types-aiobotocore-appmesh = buildTypesAiobotocorePackage "appmesh" "2.8.0" "sha256-mKQU3vw2QtGWQhIcXGzaxzTpsIG1ejQkeXzWqR1EU8Q=";

  types-aiobotocore-apprunner = buildTypesAiobotocorePackage "apprunner" "2.8.0" "sha256-76pk9XHOeSXbvbFKUwGQPcJb/Ut5b4O4+S3v7HT+SCI=";

  types-aiobotocore-appstream = buildTypesAiobotocorePackage "appstream" "2.8.0" "sha256-bMy/4tAWUEj9AjJN7/Qu+iFw0dZjtt81t0a6Dy3oeOc=";

  types-aiobotocore-appsync = buildTypesAiobotocorePackage "appsync" "2.8.0" "sha256-5pGJ3ior1etS1JK2c7wv+VzYUoB8QgEms3z2lEJiJPk=";

  types-aiobotocore-arc-zonal-shift = buildTypesAiobotocorePackage "arc-zonal-shift" "2.8.0" "sha256-84sEwc0M779PRvYUgcT2/VS+p7RH5TFOLqFPywiBY1Y=";

  types-aiobotocore-athena = buildTypesAiobotocorePackage "athena" "2.8.0" "sha256-4WiLJWVjKJE8FSmBuEg7YgytBRuWoSpXeE9csNBD+ow=";

  types-aiobotocore-auditmanager = buildTypesAiobotocorePackage "auditmanager" "2.8.0" "sha256-VztKu0+MvK5coK8SWs6FL/ciRlxls39WNtOwED9rvoI=";

  types-aiobotocore-autoscaling = buildTypesAiobotocorePackage "autoscaling" "2.8.0" "sha256-xqsgm/VIdGAXN4dqdsDWlCA0VzfAWXvzZzNhmiKab9Y=";

  types-aiobotocore-autoscaling-plans = buildTypesAiobotocorePackage "autoscaling-plans" "2.8.0" "sha256-tfpMpfTvloPaqWpoyEMNHfi6Ymkh7lA0y1mDFHAzx0Y=";

  types-aiobotocore-backup = buildTypesAiobotocorePackage "backup" "2.8.0" "sha256-m7geIWHzhqxU1SWsMkYza0XaeNYI1vOZetow2s1LDjY=";

  types-aiobotocore-backup-gateway = buildTypesAiobotocorePackage "backup-gateway" "2.8.0" "sha256-qMlqrncnxIEkdvZGN44Dh3BIFFHaSt3iylvQgn638PY=";

  types-aiobotocore-backupstorage = buildTypesAiobotocorePackage "backupstorage" "2.8.0" "sha256-djpEYsrh5qrtNUbW+ikBzCa7OXIOXm4nzMCHnAPSy60=";

  types-aiobotocore-batch = buildTypesAiobotocorePackage "batch" "2.8.0" "sha256-0S48ou1U1ljMTBGSYGwqGa0aYHdN6PDSIsHNky5RbVY=";

  types-aiobotocore-billingconductor = buildTypesAiobotocorePackage "billingconductor" "2.8.0" "sha256-SjMg8/b9Rv9XmjVqlWebjSAqnnNLJf/Il8fRyp9Uf5Q=";

  types-aiobotocore-braket = buildTypesAiobotocorePackage "braket" "2.8.0" "sha256-ZTuPhI3zOrNOknN5IWVYidDWfPC3q0M5qvJPMIubduo=";

  types-aiobotocore-budgets = buildTypesAiobotocorePackage "budgets" "2.8.0" "sha256-rr5RchXwvcf8ZQF8pjho/6BtFHzUMse/VAsFvy4z/lQ=";

  types-aiobotocore-ce = buildTypesAiobotocorePackage "ce" "2.8.0" "sha256-t26Am75QquCNPYdjKbSeXykEgkZRYKb7CRR6RBXJh3s=";

  types-aiobotocore-chime = buildTypesAiobotocorePackage "chime" "2.8.0" "sha256-bBrjIOxySDuGFAMHyJKXorwmDMtfmJdUqCbG+LA2ZbI=";

  types-aiobotocore-chime-sdk-identity = buildTypesAiobotocorePackage "chime-sdk-identity" "2.8.0" "sha256-fMwbG2A5WZ/1mbqZvdMDD+perKLIWhNLWt+Tqzx2HoM=";

  types-aiobotocore-chime-sdk-media-pipelines = buildTypesAiobotocorePackage "chime-sdk-media-pipelines" "2.8.0" "sha256-zNNSGbrlGnpx3yj1rOdXlyJ0lyBS5z/SjO/qHz00ElM=";

  types-aiobotocore-chime-sdk-meetings = buildTypesAiobotocorePackage "chime-sdk-meetings" "2.8.0" "sha256-R7lyvOfJ0/IFxzNgzjDThviGqJ/YhKUdwI67dNchFQ4=";

  types-aiobotocore-chime-sdk-messaging = buildTypesAiobotocorePackage "chime-sdk-messaging" "2.8.0" "sha256-nMnZAW5ISP9GMlvJFbGSK07oSnTA13QqxMtkIK9gel0=";

  types-aiobotocore-chime-sdk-voice = buildTypesAiobotocorePackage "chime-sdk-voice" "2.8.0" "sha256-tKTa/QHFVuxYI4k3CPfGLNJeaLj6zYtpZTrB94N53a8=";

  types-aiobotocore-cleanrooms = buildTypesAiobotocorePackage "cleanrooms" "2.8.0" "sha256-knD9hkqQkdLuFAIKH0S00ASAGMLocCY0n/vpd7+n0GE=";

  types-aiobotocore-cloud9 = buildTypesAiobotocorePackage "cloud9" "2.8.0" "sha256-Y6/YwykcKW3HbTjinru1qpzTAMlddIkFw7SvMpmNyCk=";

  types-aiobotocore-cloudcontrol = buildTypesAiobotocorePackage "cloudcontrol" "2.8.0" "sha256-1C6spvemQ1WzHVQZuDbezfFMkJ6syAbFbLATQwyBZtc=";

  types-aiobotocore-clouddirectory = buildTypesAiobotocorePackage "clouddirectory" "2.8.0" "sha256-aUOBhHnNUerjhIrSExrc4EIDPSHh/XxbUp/PFg7uvWc=";

  types-aiobotocore-cloudformation = buildTypesAiobotocorePackage "cloudformation" "2.8.0" "sha256-d+noaSxDVvJCPNfHtMi9atEAv89DQvqeE3XfpF9LOK8=";

  types-aiobotocore-cloudfront = buildTypesAiobotocorePackage "cloudfront" "2.8.0" "sha256-bq2rlB1ZLNC6px5JLfNvUBcBW4RtCoVgoWxv3A2kvk8=";

  types-aiobotocore-cloudhsm = buildTypesAiobotocorePackage "cloudhsm" "2.8.0" "sha256-kwgziSxlWJv52iKNxfFLpvzS1gHoYxC7RUmlX1TVDy0=";

  types-aiobotocore-cloudhsmv2 = buildTypesAiobotocorePackage "cloudhsmv2" "2.8.0" "sha256-zBXksiAWMns5Jnoa34FINjkpXwiwhjjRKYX1lpRtlN0=";

  types-aiobotocore-cloudsearch = buildTypesAiobotocorePackage "cloudsearch" "2.8.0" "sha256-N4GAfbF2PWvzEA0zrJTI3QbLiiFm24M+5FP3NjDcao0=";

  types-aiobotocore-cloudsearchdomain = buildTypesAiobotocorePackage "cloudsearchdomain" "2.8.0" "sha256-DW3ap0LIE1V8eD9ARJbgtYKYLvBIluULWNJ2+WcrpPU=";

  types-aiobotocore-cloudtrail = buildTypesAiobotocorePackage "cloudtrail" "2.8.0" "sha256-6/0xJRTqXDtE6MrYwtTE9QnuhK4fLi0oybDuPs/F+B8=";

  types-aiobotocore-cloudtrail-data = buildTypesAiobotocorePackage "cloudtrail-data" "2.8.0" "sha256-2F/an3hVpMI85xGQyfLFWnyCyo0rKEpPeWBo6ILWF54=";

  types-aiobotocore-cloudwatch = buildTypesAiobotocorePackage "cloudwatch" "2.8.0" "sha256-qQrfYLcfX/0mRtBCOmAQHZwR3zbV7IsNDFV0ykJCuFw=";

  types-aiobotocore-codeartifact = buildTypesAiobotocorePackage "codeartifact" "2.8.0" "sha256-7EJIKZ25ZA82bf8uU1kbxZEkzpyuaf79mDP40VdjWWM=";

  types-aiobotocore-codebuild = buildTypesAiobotocorePackage "codebuild" "2.8.0" "sha256-YXSPRxsl863LS47LBsEmTqiaCAuY0ouhqfDyj5VOrv8=";

  types-aiobotocore-codecatalyst = buildTypesAiobotocorePackage "codecatalyst" "2.8.0" "sha256-tsz4qg8ssAsoLSHYRVOp0ghu4RMA/9h/o72bRUW/7Aw=";

  types-aiobotocore-codecommit = buildTypesAiobotocorePackage "codecommit" "2.8.0" "sha256-n1VEViswcAUTFIAPDz2zWFYVPAG2NC46puBzP0zNv0E=";

  types-aiobotocore-codedeploy = buildTypesAiobotocorePackage "codedeploy" "2.8.0" "sha256-gSmJKijCivSIkgPZti5FleLVMiWqLnLJ7wauUosw+Cw=";

  types-aiobotocore-codeguru-reviewer = buildTypesAiobotocorePackage "codeguru-reviewer" "2.8.0" "sha256-VsajDkzOcj03DgkNjvQxN6YkDZvZ5gyNASOV5hHeq7o=";

  types-aiobotocore-codeguru-security = buildTypesAiobotocorePackage "codeguru-security" "2.8.0" "sha256-Oim8bYEgvOZSMRDJ9P7uRiOcmTb3N6EiOGt8TmUgbpg=";

  types-aiobotocore-codeguruprofiler = buildTypesAiobotocorePackage "codeguruprofiler" "2.8.0" "sha256-royRK5ELM8Z2fgoIYVtQVaNgDS8jE10cwRVRlP7llXA=";

  types-aiobotocore-codepipeline = buildTypesAiobotocorePackage "codepipeline" "2.8.0" "sha256-zKCzBEpZcwwvjkdQl+fNIkkLBPz58LREriYGQ4eJmkA=";

  types-aiobotocore-codestar = buildTypesAiobotocorePackage "codestar" "2.8.0" "sha256-NaRDyPKZewpsBZyZWohqxVZJ7MmzwS3691CcrAROeHY=";

  types-aiobotocore-codestar-connections = buildTypesAiobotocorePackage "codestar-connections" "2.8.0" "sha256-pmqVB/DKGDbVjhXfdIeEbnKP8ypZZhIwE/7rim2OCss=";

  types-aiobotocore-codestar-notifications = buildTypesAiobotocorePackage "codestar-notifications" "2.8.0" "sha256-KURihIUc/9HOCoGlywltbujh3XOuBNCiaAVYsLsG0ls=";

  types-aiobotocore-cognito-identity = buildTypesAiobotocorePackage "cognito-identity" "2.8.0" "sha256-Owvm6zxUQe+MtrspLuSPxx3ie6ylG/ElXVLrdXJzP/4=";

  types-aiobotocore-cognito-idp = buildTypesAiobotocorePackage "cognito-idp" "2.8.0" "sha256-oKCtGQYbWtqMzSzx6FK3+jGwYfNXyztEBVowDOAOUfw=";

  types-aiobotocore-cognito-sync = buildTypesAiobotocorePackage "cognito-sync" "2.8.0" "sha256-EcVaX6bv5yhxxJtKfZdAR8E91v02OIr8t27nQSQQ348=";

  types-aiobotocore-comprehend = buildTypesAiobotocorePackage "comprehend" "2.8.0" "sha256-4mvabiQmzJ8AhHpwr81ypQIWDOaxYZczrwhnubFP0AM=";

  types-aiobotocore-comprehendmedical = buildTypesAiobotocorePackage "comprehendmedical" "2.8.0" "sha256-KaNZF8MkD6/rD3d+ttULQEbx5XWTx4Jidd3PyRROoJM=";

  types-aiobotocore-compute-optimizer = buildTypesAiobotocorePackage "compute-optimizer" "2.8.0" "sha256-tCSPh8w+Z6DtCdfDWUZZ4d5NU5gLnTz5vS8peOFo78s=";

  types-aiobotocore-config = buildTypesAiobotocorePackage "config" "2.8.0" "sha256-FHGQPr4ffAZOp4j2YMNtHlnDNNhPw6eUrgsZB26EfPg=";

  types-aiobotocore-connect = buildTypesAiobotocorePackage "connect" "2.8.0" "sha256-9hcI+d+jXFRT9b7Sz4hk0Dh3At/U8m8Fnp/kh9W8R58=";

  types-aiobotocore-connect-contact-lens = buildTypesAiobotocorePackage "connect-contact-lens" "2.8.0" "sha256-4rbJt87KAKaQyNdB+4HjomtrHeF37orixFgM3ZliX40=";

  types-aiobotocore-connectcampaigns = buildTypesAiobotocorePackage "connectcampaigns" "2.8.0" "sha256-VgNcK7WG8AwW/FeiMXIP426cuYgfYTuM83iKLMCdSao=";

  types-aiobotocore-connectcases = buildTypesAiobotocorePackage "connectcases" "2.8.0" "sha256-fG5K6MqRz0TkawqzSw5kG5dgg5/RQ+lwkbHHfodTL+0=";

  types-aiobotocore-connectparticipant = buildTypesAiobotocorePackage "connectparticipant" "2.8.0" "sha256-BBPPTCfXWzgeSX2Z0u/h4tPOvXa5h//D76nok8pYDsk=";

  types-aiobotocore-controltower = buildTypesAiobotocorePackage "controltower" "2.8.0" "sha256-QGwSsXsqVHByl6dZmJdsVo/Ox59hnnDWMWD7NbFNVmM=";

  types-aiobotocore-cur = buildTypesAiobotocorePackage "cur" "2.8.0" "sha256-bdMw5CRpYlqdLM1wFckX0h6k7piWLxvxnoe1m7BJfAA=";

  types-aiobotocore-customer-profiles = buildTypesAiobotocorePackage "customer-profiles" "2.8.0" "sha256-T97SWapbhIg1FRD54qnyAvLs0+0YX5ZVoWBO5zq7UG4=";

  types-aiobotocore-databrew = buildTypesAiobotocorePackage "databrew" "2.8.0" "sha256-50wPMaGUGyDddUAa6IXmiHdtDD85ZEoQxsoGPachoyY=";

  types-aiobotocore-dataexchange = buildTypesAiobotocorePackage "dataexchange" "2.8.0" "sha256-0S22iMkvJoHpvr40CepEEJUP5K9T2kPOB+JKzi0JktM=";

  types-aiobotocore-datapipeline = buildTypesAiobotocorePackage "datapipeline" "2.8.0" "sha256-TiipaJX01wo41VEzgSxLhfgBZxVRAyrKhhhnevysJLo=";

  types-aiobotocore-datasync = buildTypesAiobotocorePackage "datasync" "2.8.0" "sha256-LLr/S9JLpHT3FozgZjtzXwASv4GeccPbwNU65lzjaug=";

  types-aiobotocore-dax = buildTypesAiobotocorePackage "dax" "2.8.0" "sha256-7d+3z9joliSl7XDQ1FkHgqXYEI2kPn1M62E81D15j2g=";

  types-aiobotocore-detective = buildTypesAiobotocorePackage "detective" "2.8.0" "sha256-+vwERLMPe5Ha+uygROSLoW+bsGi0hWDFPQTUqGx6Hko=";

  types-aiobotocore-devicefarm = buildTypesAiobotocorePackage "devicefarm" "2.8.0" "sha256-URNJRlSUor/amET0qPFoulAIBXDJpDTFjG/6nAaUVpw=";

  types-aiobotocore-devops-guru = buildTypesAiobotocorePackage "devops-guru" "2.8.0" "sha256-CyEiHL+wiR5/cUR1ACocSSPbeCZCGaHGfTfTYrzWapE=";

  types-aiobotocore-directconnect = buildTypesAiobotocorePackage "directconnect" "2.8.0" "sha256-7c3g+e3T7iTX6J0RzdsYJZjCfwTG0Apr35HYLF3O5mA=";

  types-aiobotocore-discovery = buildTypesAiobotocorePackage "discovery" "2.8.0" "sha256-blP+kDtXBRMrHr/ln6Y0bRmNrWiOxThjUeAcWAhTUNY=";

  types-aiobotocore-dlm = buildTypesAiobotocorePackage "dlm" "2.8.0" "sha256-ZaBTDN+CU52H4bRnV1qczhLeIGyk7q2tKlq490s36Do=";

  types-aiobotocore-dms = buildTypesAiobotocorePackage "dms" "2.8.0" "sha256-ml54TuAu+VXfROUokYvR9FRG8eYHhwvVtlJb5/4hQIQ=";

  types-aiobotocore-docdb = buildTypesAiobotocorePackage "docdb" "2.8.0" "sha256-/vT6Wkfw2iCgF3vAPgZ9HJP8vxMv90ONVVfLxkaVIIE=";

  types-aiobotocore-docdb-elastic = buildTypesAiobotocorePackage "docdb-elastic" "2.8.0" "sha256-spD7EH0Q/vrdq1YEwtxRgioGrWWWAYoXGdS5qG73zgU=";

  types-aiobotocore-drs = buildTypesAiobotocorePackage "drs" "2.8.0" "sha256-f25S6KvWDeYoCBoJG/UfNk1igwnaMftlRoORw1rGJwY=";

  types-aiobotocore-ds = buildTypesAiobotocorePackage "ds" "2.8.0" "sha256-v0G12k/bIshmiOcyg7AuLNzytqpWGH5qFLFvcxhTNz4=";

  types-aiobotocore-dynamodb = buildTypesAiobotocorePackage "dynamodb" "2.8.0" "sha256-2lVSmrTDTaIaahOa/jp1vQcv7C7OU24Tse21u4LacCs=";

  types-aiobotocore-dynamodbstreams = buildTypesAiobotocorePackage "dynamodbstreams" "2.8.0" "sha256-gZmm8UUPiPyIZvCO6ffEy7Lq6Q5KeMs5E1bj2ohSORs=";

  types-aiobotocore-ebs = buildTypesAiobotocorePackage "ebs" "2.8.0" "sha256-yf6w8gbyo4y1XnFK8lLt8XUL45XSLoXA+MepuqvQHCg=";

  types-aiobotocore-ec2 = buildTypesAiobotocorePackage "ec2" "2.8.0" "sha256-U6vuxYzmWSr9tkh1kbRNYTmRtVbjGqHWqgFimJxH72E=";

  types-aiobotocore-ec2-instance-connect = buildTypesAiobotocorePackage "ec2-instance-connect" "2.8.0" "sha256-TGfpfuEXcjhy1hrAh9fKH7B8XTdhBfQ4vlzDk/kssTs=";

  types-aiobotocore-ecr = buildTypesAiobotocorePackage "ecr" "2.8.0" "sha256-VgyDlLTgaTTTt8l8Li/BWvdJYCtPtIpXoLDU7si0QAY=";

  types-aiobotocore-ecr-public = buildTypesAiobotocorePackage "ecr-public" "2.8.0" "sha256-GW7FwDUmsgqbI/H/lNnqgYUkN4X75hypdnyBfiJYISc=";

  types-aiobotocore-ecs = buildTypesAiobotocorePackage "ecs" "2.8.0" "sha256-A16c14ccCvuy+PIMEKvmCyJxoKmZoIwHSyGFAe6jzHo=";

  types-aiobotocore-efs = buildTypesAiobotocorePackage "efs" "2.8.0" "sha256-3DF/GvvCJetJyyJc7pQG9mMmqdfW+96UBwlBxOxP3XQ=";

  types-aiobotocore-eks = buildTypesAiobotocorePackage "eks" "2.8.0" "sha256-eoUHLMl0o9ZeKdhlB0RYPanhfDXJcKarKfOcKLHex4I=";

  types-aiobotocore-elastic-inference = buildTypesAiobotocorePackage "elastic-inference" "2.8.0" "sha256-kFmVPs5s/IpP2tdeZDrIZt/b9TU391eRjW0ZdzQtjFw=";

  types-aiobotocore-elasticache = buildTypesAiobotocorePackage "elasticache" "2.8.0" "sha256-FPhZJgbXhpaTWf3Y3LBHIq34eUcjXpXC91hygddmdEs=";

  types-aiobotocore-elasticbeanstalk = buildTypesAiobotocorePackage "elasticbeanstalk" "2.8.0" "sha256-OOUnw+mdFa1NFd2y3ZyHnKpxDgbwyYkTKWd2RZU9zS4=";

  types-aiobotocore-elastictranscoder = buildTypesAiobotocorePackage "elastictranscoder" "2.8.0" "sha256-cf7wUcsGZqm4KU7v85AIvHpNM2cwwRfaPYRC8F977tc=";

  types-aiobotocore-elb = buildTypesAiobotocorePackage "elb" "2.8.0" "sha256-qtLIXieOk9lhcZbfO5K2xVKYBx0HCXMvAfPpGIGAJ6c=";

  types-aiobotocore-elbv2 = buildTypesAiobotocorePackage "elbv2" "2.8.0" "sha256-OWow8bdLey5/PtSpeOIj6h54bqoQfQ8JKVM16UW1AYg=";

  types-aiobotocore-emr = buildTypesAiobotocorePackage "emr" "2.8.0" "sha256-Q8kSD8x3wt5IZ+24aT1zWfdxQ39AEjNOgUbQu16FhI0=";

  types-aiobotocore-emr-containers = buildTypesAiobotocorePackage "emr-containers" "2.8.0" "sha256-vsioxVeIVvz+tY5OLroU2soCkZyEd+FO5HKN9eoBtGA=";

  types-aiobotocore-emr-serverless = buildTypesAiobotocorePackage "emr-serverless" "2.8.0" "sha256-5Q5cJjcKtGTDrdn8bgE+OjpyUJOdPDXHn8QF83f+ubA=";

  types-aiobotocore-entityresolution = buildTypesAiobotocorePackage "entityresolution" "2.8.0" "sha256-+3Y4KbPdnbhArlXi307a0+v6heQKY8Ot+DrjiND2qvo=";

  types-aiobotocore-es = buildTypesAiobotocorePackage "es" "2.8.0" "sha256-E7aB4eyePZZ2r4Ssm27q2joppoGMkRI8Wy7sL0bBDUQ=";

  types-aiobotocore-events = buildTypesAiobotocorePackage "events" "2.8.0" "sha256-VCoKp5d+bl7+x2ytIrKaD12uO41qyDTS0GScuWff4MA=";

  types-aiobotocore-evidently = buildTypesAiobotocorePackage "evidently" "2.8.0" "sha256-6Rh+9NzGRbFXF2ywE/q6SV6PwDgFgZvScoNkr9T3sZg=";

  types-aiobotocore-finspace = buildTypesAiobotocorePackage "finspace" "2.8.0" "sha256-EO38upjPJy7jonxOynE07eN04MDd+WfNkJoinrQZVgY=";

  types-aiobotocore-finspace-data = buildTypesAiobotocorePackage "finspace-data" "2.8.0" "sha256-28QBXGIuxWUGF5aiokxFRhEoHaK3XjeEjZJzA5luvMo=";

  types-aiobotocore-firehose = buildTypesAiobotocorePackage "firehose" "2.8.0" "sha256-QGIMg0SfTpj1ScHsEsp9dMikNGRxbJ/8RmwuouQvGSs=";

  types-aiobotocore-fis = buildTypesAiobotocorePackage "fis" "2.8.0" "sha256-ePYrb4K8gyuLNmYgUZvOHclFraK3sYSt+NwTyBjSt8A=";

  types-aiobotocore-fms = buildTypesAiobotocorePackage "fms" "2.8.0" "sha256-9TZhIEBwYO9442veI9rINUCVYbJvvdcBfYnlF6Wgt0w=";

  types-aiobotocore-forecast = buildTypesAiobotocorePackage "forecast" "2.8.0" "sha256-cdVmSqqR9NhYEKBza+bWAmOuasCNbO3dG7zn4qgSdws=";

  types-aiobotocore-forecastquery = buildTypesAiobotocorePackage "forecastquery" "2.8.0" "sha256-la6LEpXrunQgsjCkKUuVKZgRFRAU0gC+GnLQ5iIsIkI=";

  types-aiobotocore-frauddetector = buildTypesAiobotocorePackage "frauddetector" "2.8.0" "sha256-9GIxWYLp9CzyK8UUYIpVgDxF5iUCtd05+7mRYJYdjrk=";

  types-aiobotocore-fsx = buildTypesAiobotocorePackage "fsx" "2.8.0" "sha256-TsHhIEv90847QEX6ZgipnQ2zaTkWgDXMGRL1m6U1VF0=";

  types-aiobotocore-gamelift = buildTypesAiobotocorePackage "gamelift" "2.8.0" "sha256-abYWCco23+IPKmBsJxlhzu0x9jyAy/h4QwPM5Elifoc=";

  types-aiobotocore-gamesparks = buildTypesAiobotocorePackage "gamesparks" "2.6.0" "sha256-9iV7bpGMnzz9TH+g1YpPjbKBSKY3rcL/OJvMOzwLC1M=";

  types-aiobotocore-glacier = buildTypesAiobotocorePackage "glacier" "2.8.0" "sha256-GcNrtfUzhXefhTzbHa97UI/N7yaGLgMu0aJeo8WG1U8=";

  types-aiobotocore-globalaccelerator = buildTypesAiobotocorePackage "globalaccelerator" "2.8.0" "sha256-b2GoHqcX7PPzo519rgvd628dgkRZWt+m8SLG3vS66Ag=";

  types-aiobotocore-glue = buildTypesAiobotocorePackage "glue" "2.8.0" "sha256-BRUmyStCMakZGwu0HXZYk/cbJv0LuVmiUfFK/I0mwTQ=";

  types-aiobotocore-grafana = buildTypesAiobotocorePackage "grafana" "2.8.0" "sha256-ac/wgoPE5GW2EKvyHdlfpq7C8qEHsbZypeSzeztKeyw=";

  types-aiobotocore-greengrass = buildTypesAiobotocorePackage "greengrass" "2.8.0" "sha256-JTL/sa7d11x59/Rg08LWtir6qe3jFl+acyjR4qM3BVI=";

  types-aiobotocore-greengrassv2 = buildTypesAiobotocorePackage "greengrassv2" "2.8.0" "sha256-whuWWF0xWEyYLfhjL4gQIYVRoNH+KcJBpJ/9797skn8=";

  types-aiobotocore-groundstation = buildTypesAiobotocorePackage "groundstation" "2.8.0" "sha256-WHsizbn5+L3Lk25bZf90G61ndJA4H34h4sZjhdJ0KHU=";

  types-aiobotocore-guardduty = buildTypesAiobotocorePackage "guardduty" "2.8.0" "sha256-b/JbVyWLxmzfQP5RFwFcWxbvMxJL5EZZj/qDJIo/v6o=";

  types-aiobotocore-health = buildTypesAiobotocorePackage "health" "2.8.0" "sha256-WknloMADb2N8iIQgpre6pKL9I1Xnf0yLaqu+H1NltEk=";

  types-aiobotocore-healthlake = buildTypesAiobotocorePackage "healthlake" "2.8.0" "sha256-SIRHkOJnivOxTnyvFCIiYrOxgq1K4abAe6ug5E2xYGA=";

  types-aiobotocore-honeycode = buildTypesAiobotocorePackage "honeycode" "2.8.0" "sha256-IssoNzRVyHdc9SvBrzBnekUCpV9zG0Tsd2fd7NlMBDQ=";

  types-aiobotocore-iam = buildTypesAiobotocorePackage "iam" "2.8.0" "sha256-OG0989m7yAWgNDOk8L21p95ShJyfDH7ITGVIjYT8LNU=";

  types-aiobotocore-identitystore = buildTypesAiobotocorePackage "identitystore" "2.8.0" "sha256-Te5zV+wjrZAUvH/v0umOfs/L6h6bij8+a6cTQ/OavEw=";

  types-aiobotocore-imagebuilder = buildTypesAiobotocorePackage "imagebuilder" "2.8.0" "sha256-4ogMLE65UK7rUZME0Lw6Tr0YN12w49WpcMMILURIJmI=";

  types-aiobotocore-importexport = buildTypesAiobotocorePackage "importexport" "2.8.0" "sha256-27gETFJhrTm8XEP8Ox1EeUmoPRRvt9fL/xwvYkDp+0M=";

  types-aiobotocore-inspector = buildTypesAiobotocorePackage "inspector" "2.8.0" "sha256-nVboEaKNKDxVTeK6nbxWfIy3BwXZntX8Gvb+eA4S0JQ=";

  types-aiobotocore-inspector2 = buildTypesAiobotocorePackage "inspector2" "2.8.0" "sha256-lDSpabN4WiqSuHEpHwpAgOIDAWVK3gj7gnmMrOb5EN8=";

  types-aiobotocore-internetmonitor = buildTypesAiobotocorePackage "internetmonitor" "2.8.0" "sha256-40MuIYHCKg2632yRA/vJg0eOv4cNHbzN4w2I9Qi3gms=";

  types-aiobotocore-iot = buildTypesAiobotocorePackage "iot" "2.8.0" "sha256-/t5dRl3Kbri/Em6YiWhNRIDjS8KSQZNkx/X7yWTR6/c=";

  types-aiobotocore-iot-data = buildTypesAiobotocorePackage "iot-data" "2.8.0" "sha256-nozk/q5hK94LImV+I80nlPm2Q7hVCzGU5ngOLrW8jVo=";

  types-aiobotocore-iot-jobs-data = buildTypesAiobotocorePackage "iot-jobs-data" "2.8.0" "sha256-iwkxJNDboNQVXnm5UVZ/n1+TtSZm0vVUZyQs+rGpFzE=";

  types-aiobotocore-iot-roborunner = buildTypesAiobotocorePackage "iot-roborunner" "2.8.0" "sha256-SnDBBZqjP0n291gy8wl9xjDejQjEu7Xwp4wCN6R0qt0=";

  types-aiobotocore-iot1click-devices = buildTypesAiobotocorePackage "iot1click-devices" "2.8.0" "sha256-+yfTXuyYUD9KHRmOEtYzDTbH9miJ+piI3EfT3eKhfPk=";

  types-aiobotocore-iot1click-projects = buildTypesAiobotocorePackage "iot1click-projects" "2.8.0" "sha256-FlhYtD34tO5tQrcPmHNya+33abKEb88IRLnnXxwA+YQ=";

  types-aiobotocore-iotanalytics = buildTypesAiobotocorePackage "iotanalytics" "2.8.0" "sha256-BnWehHwrmywOC7Dce0dvEBVSHxnm78Kh9oqciL3UdIo=";

  types-aiobotocore-iotdeviceadvisor = buildTypesAiobotocorePackage "iotdeviceadvisor" "2.8.0" "sha256-Oa7sjr6XaHm0xrkLErBUlN6x9hqLLT70e1jmlCngd/c=";

  types-aiobotocore-iotevents = buildTypesAiobotocorePackage "iotevents" "2.8.0" "sha256-PQ6IRTBMrW+4/Lad7y+aIr73iTDKLgMQxSM5mLRHdMA=";

  types-aiobotocore-iotevents-data = buildTypesAiobotocorePackage "iotevents-data" "2.8.0" "sha256-gbVRHSyYwkD/Fahy0uFZJ71nZajc2ra04Vyptrm+12E=";

  types-aiobotocore-iotfleethub = buildTypesAiobotocorePackage "iotfleethub" "2.8.0" "sha256-k0oLgKH4D6HUQOIdF1WBhcIPDe7bkE/8iEthVY3GxcE=";

  types-aiobotocore-iotfleetwise = buildTypesAiobotocorePackage "iotfleetwise" "2.8.0" "sha256-22LIZgrsNzGAjW9K+BJAgE/BcyY1SplQFVcRncx7FxI=";

  types-aiobotocore-iotsecuretunneling = buildTypesAiobotocorePackage "iotsecuretunneling" "2.8.0" "sha256-6Pec8uYl4diA7V6gNhUrrocMvRSfmbfL6UhJ1MM36DQ=";

  types-aiobotocore-iotsitewise = buildTypesAiobotocorePackage "iotsitewise" "2.8.0" "sha256-+s2fRs6c/5/Q+72Eg7E9QmEk78o/Vg33WaQ/dA0ETAw=";

  types-aiobotocore-iotthingsgraph = buildTypesAiobotocorePackage "iotthingsgraph" "2.8.0" "sha256-cCD0v23PWxUEvTSonDz+B8a4a+EAwUP9J4IOnIVP4VQ=";

  types-aiobotocore-iottwinmaker = buildTypesAiobotocorePackage "iottwinmaker" "2.8.0" "sha256-L+MVCQ0RMa9v5/fRirAQFzPZwfNR4pCmycKuflYrdzE=";

  types-aiobotocore-iotwireless = buildTypesAiobotocorePackage "iotwireless" "2.8.0" "sha256-po1Hnh51v5d1Q3XVU0gu4ss9QPFai5NUfOVhRGYJnvo=";

  types-aiobotocore-ivs = buildTypesAiobotocorePackage "ivs" "2.8.0" "sha256-T68P1ccYgmixKvMSfFQ39G9gEXKs0MSdX5quyV8xbkY=";

  types-aiobotocore-ivs-realtime = buildTypesAiobotocorePackage "ivs-realtime" "2.8.0" "sha256-MKFEunzwmhkDahqjPqXd/zTuFIMlcpjIeb0DEze/7YQ=";

  types-aiobotocore-ivschat = buildTypesAiobotocorePackage "ivschat" "2.8.0" "sha256-Bz57PqqBgRY6NEIDX3lAIeRg+Iqsv4eoeTZt1Us38m0=";

  types-aiobotocore-kafka = buildTypesAiobotocorePackage "kafka" "2.8.0" "sha256-eNUSf2MjSraDN6CG9RdsmWQYmIybqHwXgMNspBrJrb8=";

  types-aiobotocore-kafkaconnect = buildTypesAiobotocorePackage "kafkaconnect" "2.8.0" "sha256-iRGe/VeSY7WILNzo3acJgfetOW4k1qKRwM4zov1423k=";

  types-aiobotocore-kendra = buildTypesAiobotocorePackage "kendra" "2.8.0" "sha256-cg4SlEYrFH+b8nvDeSBARdIraQic9MKybJNexM/PRJ0=";

  types-aiobotocore-kendra-ranking = buildTypesAiobotocorePackage "kendra-ranking" "2.8.0" "sha256-vIDdXNmrmwu4+j+hQLFMZ4V3RRSIeA4/zW1rBieFb00=";

  types-aiobotocore-keyspaces = buildTypesAiobotocorePackage "keyspaces" "2.8.0" "sha256-PkaBaYS7QLLwKXBEOzGMH0ClkDp06lCF4Q5SAklNyaI=";

  types-aiobotocore-kinesis = buildTypesAiobotocorePackage "kinesis" "2.8.0" "sha256-/Xm+yspnTA1zcBRJpteFa+nv958XLiM54lqzPqLy6LY=";

  types-aiobotocore-kinesis-video-archived-media = buildTypesAiobotocorePackage "kinesis-video-archived-media" "2.8.0" "sha256-kNq2F4BiLqCFaPWPRP/yMfVtUmeTOnv3zdglW/r/UxE=";

  types-aiobotocore-kinesis-video-media = buildTypesAiobotocorePackage "kinesis-video-media" "2.8.0" "sha256-Ir5qnsd8n3fuEbSkFu+iMb+r1qASHZD2JcQdMvXlQO4=";

  types-aiobotocore-kinesis-video-signaling = buildTypesAiobotocorePackage "kinesis-video-signaling" "2.8.0" "sha256-5hhNHELrmQnGnNDaBkeuYNMx9vljiDNLPuOOeHloHXU=";

  types-aiobotocore-kinesis-video-webrtc-storage = buildTypesAiobotocorePackage "kinesis-video-webrtc-storage" "2.8.0" "sha256-qobp+/oElcwlYNIxsrI0S8GGV++CnvO4O1So2acyYto=";

  types-aiobotocore-kinesisanalytics = buildTypesAiobotocorePackage "kinesisanalytics" "2.8.0" "sha256-JFz1l+iA9eMQGdvJYNdz2NvqpWggzRoOEFTUexhVH9o=";

  types-aiobotocore-kinesisanalyticsv2 = buildTypesAiobotocorePackage "kinesisanalyticsv2" "2.8.0" "sha256-66Mv1d/h1TFKHbA2wclYvlLNgdhaxM01OTghPPQErLI=";

  types-aiobotocore-kinesisvideo = buildTypesAiobotocorePackage "kinesisvideo" "2.8.0" "sha256-+tPbtG2X8deDjC23e/64CZ8mEbGzmS5ThDVjt1RrFtE=";

  types-aiobotocore-kms = buildTypesAiobotocorePackage "kms" "2.8.0" "sha256-PMKkT6vIs/Qix8N2HqgoM9F7oH5GX5bZnVC2TtJQjgA=";

  types-aiobotocore-lakeformation = buildTypesAiobotocorePackage "lakeformation" "2.8.0" "sha256-dtm2xetYQ/9lUKGOgunTvNQDLoqu8q7YIhkf2GKWVyo=";

  types-aiobotocore-lambda = buildTypesAiobotocorePackage "lambda" "2.8.0" "sha256-SMEIIrua1lma7uMlFjlU6lRj34cy1tAe8J5QTqr8ffA=";

  types-aiobotocore-lex-models = buildTypesAiobotocorePackage "lex-models" "2.8.0" "sha256-Rdd6zRTmn0rciGg9OrkGRbwLzN/qI+JjgylbtWy8/gU=";

  types-aiobotocore-lex-runtime = buildTypesAiobotocorePackage "lex-runtime" "2.8.0" "sha256-suwMfcgffGOGDUaeZgGklDyE7S2FK4ft/hwYlb2GkSY=";

  types-aiobotocore-lexv2-models = buildTypesAiobotocorePackage "lexv2-models" "2.8.0" "sha256-wKNauKxrrR/Vx76RedpTH1wwJv+vS3avb7x5IkqFiuc=";

  types-aiobotocore-lexv2-runtime = buildTypesAiobotocorePackage "lexv2-runtime" "2.8.0" "sha256-SHOMEY1sS50PCAn9tHKSd1Xu2Fk8v1XW3n9OH/z+WCk=";

  types-aiobotocore-license-manager = buildTypesAiobotocorePackage "license-manager" "2.8.0" "sha256-agkuc41utwpZG5CdKt6wzLXWo/rlho4wvnRJQlyBEEQ=";

  types-aiobotocore-license-manager-linux-subscriptions = buildTypesAiobotocorePackage "license-manager-linux-subscriptions" "2.8.0" "sha256-I50/A3TUWjf4fzATA1E3TOlSLt8fjUTNJNwGZyRTvN4=";

  types-aiobotocore-license-manager-user-subscriptions = buildTypesAiobotocorePackage "license-manager-user-subscriptions" "2.8.0" "sha256-CreNvz6ympQ5J2FO61pDGzQn+3fm+PkmgNWu0VVcPlk=";

  types-aiobotocore-lightsail = buildTypesAiobotocorePackage "lightsail" "2.8.0" "sha256-Yl+HggZfJUh+zpb6TCTX7iDZXLlepiDgn23Gg7VO+mA=";

  types-aiobotocore-location = buildTypesAiobotocorePackage "location" "2.8.0" "sha256-1gim+G8UlGjVTk/UWFdjqCTZqVFXTXNQXottnNG6Ixs=";

  types-aiobotocore-logs = buildTypesAiobotocorePackage "logs" "2.8.0" "sha256-OtEwyQN3NqMKorgfiSNs/HD8ojcpsqCqhgkLz4YIrwE=";

  types-aiobotocore-lookoutequipment = buildTypesAiobotocorePackage "lookoutequipment" "2.8.0" "sha256-b/vxkp9iou75uyuDtbK59L3L6gUsHe3aeK1d7NW9LfA=";

  types-aiobotocore-lookoutmetrics = buildTypesAiobotocorePackage "lookoutmetrics" "2.8.0" "sha256-3KLXy6uN58VNE6x5ZbX+LFhTJz6Vwmp14d33dRCLVjM=";

  types-aiobotocore-lookoutvision = buildTypesAiobotocorePackage "lookoutvision" "2.8.0" "sha256-M5B+jYeD12lcfwo7wMQcQhC5IIY0dDgUGI+c5cH/IZ4=";

  types-aiobotocore-m2 = buildTypesAiobotocorePackage "m2" "2.8.0" "sha256-ICdR9U35k/RKjqnzHC6Gnyg0xAwGK5049apIjR6JkmE=";

  types-aiobotocore-machinelearning = buildTypesAiobotocorePackage "machinelearning" "2.8.0" "sha256-kqg2ElTdAnxKZmNWVQxBDSW4OABiETVa2CPiv89Z8S0=";

  types-aiobotocore-macie = buildTypesAiobotocorePackage "macie" "2.6.0" "sha256-gbl7jEgjk4twoxGM+WRg4MZ/nkGg7btiPOsPptR7yfw=";

  types-aiobotocore-macie2 = buildTypesAiobotocorePackage "macie2" "2.8.0" "sha256-VFjPIdUbWmzbQLowlv9/R6RejjXIlI4odOc90xFIddQ=";

  types-aiobotocore-managedblockchain = buildTypesAiobotocorePackage "managedblockchain" "2.8.0" "sha256-QWrhzab5MFOOWrlhkwlXyyFx4yRPKQbbW8KxqLAxU7E=";

  types-aiobotocore-managedblockchain-query = buildTypesAiobotocorePackage "managedblockchain-query" "2.8.0" "sha256-F88BhmFRiU/wYHSgk0+iupLdI5nrD/hhp+fDgyfwilM=";

  types-aiobotocore-marketplace-catalog = buildTypesAiobotocorePackage "marketplace-catalog" "2.8.0" "sha256-1HOSZnvboIvb5ApQnADgSwJac3mQi16xtXuU5JGMudQ=";

  types-aiobotocore-marketplace-entitlement = buildTypesAiobotocorePackage "marketplace-entitlement" "2.8.0" "sha256-63r5ZWbQIqf52VnF2R7o0PQoZlpr8Qq1YCW+UDFATjs=";

  types-aiobotocore-marketplacecommerceanalytics = buildTypesAiobotocorePackage "marketplacecommerceanalytics" "2.8.0" "sha256-a88m9GasfGk/NEyc3rdD4hkroqcJ3aDBXZBjifJqMPI=";

  types-aiobotocore-mediaconnect = buildTypesAiobotocorePackage "mediaconnect" "2.8.0" "sha256-8VATnN1PtxWs/yJokcJcmAxa4gFroiH7gfCwMWfwrp4=";

  types-aiobotocore-mediaconvert = buildTypesAiobotocorePackage "mediaconvert" "2.8.0" "sha256-6ho22HIqC2kB53psJYJwuFpyenpfr0aVlozOdFEW19w=";

  types-aiobotocore-medialive = buildTypesAiobotocorePackage "medialive" "2.8.0" "sha256-RCjrki2KQASXIpd4i6XKPKWLVSzUCTFKN/o8wAwnOMA=";

  types-aiobotocore-mediapackage = buildTypesAiobotocorePackage "mediapackage" "2.8.0" "sha256-evq8LtTmpIsSU/gW6/PYMGw96aqy/Bfo42b538Gtd4U=";

  types-aiobotocore-mediapackage-vod = buildTypesAiobotocorePackage "mediapackage-vod" "2.8.0" "sha256-9YSYyjyCocfjrah3hTrUEpEjZYuiwt8GaDyvc/ogius=";

  types-aiobotocore-mediapackagev2 = buildTypesAiobotocorePackage "mediapackagev2" "2.8.0" "sha256-hT62oK9VXVcOzTXD6cVk8e1PKOdo60yM92hGBCFLz98=";

  types-aiobotocore-mediastore = buildTypesAiobotocorePackage "mediastore" "2.8.0" "sha256-HPJnlV6RlewLpJ/Wg4oaOxJVMw2jrVRVxVwtdKrXzNA=";

  types-aiobotocore-mediastore-data = buildTypesAiobotocorePackage "mediastore-data" "2.8.0" "sha256-uuB9ysAebww5JDftftIU75l3c1b5R1FCk159UcoyH0Q=";

  types-aiobotocore-mediatailor = buildTypesAiobotocorePackage "mediatailor" "2.8.0" "sha256-gV53OmupgM6JD0V3KbK8e3NaVf2viUdxFj+6pWNd9gw=";

  types-aiobotocore-medical-imaging = buildTypesAiobotocorePackage "medical-imaging" "2.8.0" "sha256-nr1BcwhbQPLJQeHrL9QmYBC4tyl16CaMVUIodtAs368=";

  types-aiobotocore-memorydb = buildTypesAiobotocorePackage "memorydb" "2.8.0" "sha256-cXMDqWSiRWkehXQlmzL/3tCC0OYMmTqK7CAc45bXrO4=";

  types-aiobotocore-meteringmarketplace = buildTypesAiobotocorePackage "meteringmarketplace" "2.8.0" "sha256-Kz7huJpsAyNTLaBjNNYRXnnLG1W9yXUcmH06cf6yvAg=";

  types-aiobotocore-mgh = buildTypesAiobotocorePackage "mgh" "2.8.0" "sha256-854ZymXpthw99nHiE9CmYeW8T7rD7rFsdN4hrcrh7P4=";

  types-aiobotocore-mgn = buildTypesAiobotocorePackage "mgn" "2.8.0" "sha256-6PS+wvH3lFGSK6JgNt6bjQyyain/ISRb8ojU6FasNCM=";

  types-aiobotocore-migration-hub-refactor-spaces = buildTypesAiobotocorePackage "migration-hub-refactor-spaces" "2.8.0" "sha256-+LTl446lEgVxS+W1O9fhYAN9oGsxQ5H3pCOkTuVBX8I=";

  types-aiobotocore-migrationhub-config = buildTypesAiobotocorePackage "migrationhub-config" "2.8.0" "sha256-XzDASRMfmnSKzNiGfCF4vI6ppACUwqwe7a7FH2yNS3g=";

  types-aiobotocore-migrationhuborchestrator = buildTypesAiobotocorePackage "migrationhuborchestrator" "2.8.0" "sha256-Rghip34bceNr7OsCI0BaNmlGoJEU2DtloMtTqzQrOqo=";

  types-aiobotocore-migrationhubstrategy = buildTypesAiobotocorePackage "migrationhubstrategy" "2.8.0" "sha256-jcEK5kmgvFPXExUmgebZ089X4OZO4rRFmCsAe9lIP4Y=";

  types-aiobotocore-mobile = buildTypesAiobotocorePackage "mobile" "2.8.0" "sha256-Qe/gzlCT51Tz0HrmhIon5ZjFPEPh+GV18/+0A4zGGCM=";

  types-aiobotocore-mq = buildTypesAiobotocorePackage "mq" "2.8.0" "sha256-dCrFTzU0a7t7dAMWHklUe3m6/6O2FhvSMU/YRkhvk4M=";

  types-aiobotocore-mturk = buildTypesAiobotocorePackage "mturk" "2.8.0" "sha256-GyHtUoLyBMelhpeecXA760o2kMOjoUmdZNcQyxRzfPM=";

  types-aiobotocore-mwaa = buildTypesAiobotocorePackage "mwaa" "2.8.0" "sha256-TBTyn6VaHthO5ytB9dtsWB/Un1uON7iWT/YGkWFB5pI=";

  types-aiobotocore-neptune = buildTypesAiobotocorePackage "neptune" "2.8.0" "sha256-FdhFyfJm78jITAxc0b4S9/Pfhqo29ElRG09s+dEOmvM=";

  types-aiobotocore-network-firewall = buildTypesAiobotocorePackage "network-firewall" "2.8.0" "sha256-/0p6ogWaWHF5U3ZnFKAjmFZHu0TyZbr2q5/Ts18E0tI=";

  types-aiobotocore-networkmanager = buildTypesAiobotocorePackage "networkmanager" "2.8.0" "sha256-nr/6VzCy8n1/wSgTTVJuB2DRa+Hm8wwsnnLM97gq2Wk=";

  types-aiobotocore-nimble = buildTypesAiobotocorePackage "nimble" "2.8.0" "sha256-vuER3haEKEX1Dorw5FGvYr2gSHqrTPjZ8PDuMtD0A3E=";

  types-aiobotocore-oam = buildTypesAiobotocorePackage "oam" "2.8.0" "sha256-GfgKHugRZPyPhkzyZibRBodDvxYlHKW735sC7JOOSnU=";

  types-aiobotocore-omics = buildTypesAiobotocorePackage "omics" "2.8.0" "sha256-XhoBrVmqs39kFPykKvha4MX+jHrYM0eoArCASR9Pj3U=";

  types-aiobotocore-opensearch = buildTypesAiobotocorePackage "opensearch" "2.8.0" "sha256-XMdFJ81JK2dkwwb8nKgqaDFQhHoako5IFt1iygZcWUs=";

  types-aiobotocore-opensearchserverless = buildTypesAiobotocorePackage "opensearchserverless" "2.8.0" "sha256-uCd7c/vALl2DCXayCLlrvQzwANOMhKVKfSSDgkhWITE=";

  types-aiobotocore-opsworks = buildTypesAiobotocorePackage "opsworks" "2.8.0" "sha256-AI7r1EUOW9gmEgjxwLpeUvD4TsIFsZJXNx2nSrREZRU=";

  types-aiobotocore-opsworkscm = buildTypesAiobotocorePackage "opsworkscm" "2.8.0" "sha256-MrOpFV1Rvr9pqipkDAk0YfNn9W87GTARQWZTdTafM2U=";

  types-aiobotocore-organizations = buildTypesAiobotocorePackage "organizations" "2.8.0" "sha256-lXb5rXS9gNMdalbX3Bqkq/MZwnkQXjVqnBWMAacTVNo=";

  types-aiobotocore-osis = buildTypesAiobotocorePackage "osis" "2.8.0" "sha256-IJiZ6PYC2wgqHdqZ5+d2IWmfqTWzNiMouUyScv7+AeI=";

  types-aiobotocore-outposts = buildTypesAiobotocorePackage "outposts" "2.8.0" "sha256-gRaXVGJuzBpwKBP+PuHeBhBwPi7ADaMqO3yXSiwAwZI=";

  types-aiobotocore-panorama = buildTypesAiobotocorePackage "panorama" "2.8.0" "sha256-6pKdo0HePlZ8vdDagIKcAEz9FQWxdD0DCxeJGCqV1Yc=";

  types-aiobotocore-payment-cryptography = buildTypesAiobotocorePackage "payment-cryptography" "2.8.0" "sha256-FrA3aGo9VoZknc8B8dQVuvgPLutxr/sUwqXKv5GfvVU=";

  types-aiobotocore-payment-cryptography-data = buildTypesAiobotocorePackage "payment-cryptography-data" "2.8.0" "sha256-XnHVJ/FSjP4xk9Won9uBKZn50wgJgNUrNIKWUrey1UI=";

  types-aiobotocore-personalize = buildTypesAiobotocorePackage "personalize" "2.8.0" "sha256-+Gsp9WbKQY+xxmrVQzlBTYXNmio4rLrEFYiaAg4lU7s=";

  types-aiobotocore-personalize-events = buildTypesAiobotocorePackage "personalize-events" "2.8.0" "sha256-rbL+0tgTnhfx4wNCMqV/Bzs29MiVadiFVCuTR9vYNDQ=";

  types-aiobotocore-personalize-runtime = buildTypesAiobotocorePackage "personalize-runtime" "2.8.0" "sha256-87UjieqBzXgTWAFEtnNrxXAOT/0mbCtMIb77iKuGxLM=";

  types-aiobotocore-pi = buildTypesAiobotocorePackage "pi" "2.8.0" "sha256-3mU5YeNavmdeRLEhqXNklmkpNh/DEIzywgcSXoH5Vxg=";

  types-aiobotocore-pinpoint = buildTypesAiobotocorePackage "pinpoint" "2.8.0" "sha256-55EeFiHspJRWJbYcjZGZpRhKirAzvvyTxVW+/Z8OiyA=";

  types-aiobotocore-pinpoint-email = buildTypesAiobotocorePackage "pinpoint-email" "2.8.0" "sha256-hVrQQcYyqq05XlSVmZfgNVhxDpWnkAyzSjzWUP1A998=";

  types-aiobotocore-pinpoint-sms-voice = buildTypesAiobotocorePackage "pinpoint-sms-voice" "2.8.0" "sha256-CGWyKB7lGLpYPHShXShC+OVTbm9eZiQEScLd2QL4Y5s=";

  types-aiobotocore-pinpoint-sms-voice-v2 = buildTypesAiobotocorePackage "pinpoint-sms-voice-v2" "2.8.0" "sha256-xeS5Z23qOQpO2OnXH8trhr6b6BR0cEYpNFA+t+yJW7k=";

  types-aiobotocore-pipes = buildTypesAiobotocorePackage "pipes" "2.8.0" "sha256-z2eeckCHLYTLF60XG1ybVJNTuyAUr98VlXP7SZneqfU=";

  types-aiobotocore-polly = buildTypesAiobotocorePackage "polly" "2.8.0" "sha256-GwCP8lukUapXQ05O6QJg3Y3MobUdFiky2Gv4auhT6ug=";

  types-aiobotocore-pricing = buildTypesAiobotocorePackage "pricing" "2.8.0" "sha256-BSDgRuzvJXwyaF0CGHa3A+Q6sg/dAZDkEL8OG+7k4Pw=";

  types-aiobotocore-privatenetworks = buildTypesAiobotocorePackage "privatenetworks" "2.8.0" "sha256-7DeAE5HloRZ/kTi5LteeMIl0/iesoL1miemdgYW7sHI=";

  types-aiobotocore-proton = buildTypesAiobotocorePackage "proton" "2.8.0" "sha256-EbGoeT3eIUK1axbtsc+jxgN9Qw1CNC/Ak5vD8kmPnU0=";

  types-aiobotocore-qldb = buildTypesAiobotocorePackage "qldb" "2.8.0" "sha256-vPOarQWZaf+5147n3pHM0zSwVRWBTxX7eE6JCpTASeg=";

  types-aiobotocore-qldb-session = buildTypesAiobotocorePackage "qldb-session" "2.8.0" "sha256-hOPua7NJQHoA/m3j9/doMLZJKV6rfQbGdkd3fo+aKpk=";

  types-aiobotocore-quicksight = buildTypesAiobotocorePackage "quicksight" "2.8.0" "sha256-SYoyW04NxJsNP7uS3KxZpxi/PRTIS9uSVJA/sVTD/20=";

  types-aiobotocore-ram = buildTypesAiobotocorePackage "ram" "2.8.0" "sha256-QhMDbdjH/bCDLKHEFpMb41YaPf59TSEs2bu151W8IlA=";

  types-aiobotocore-rbin = buildTypesAiobotocorePackage "rbin" "2.8.0" "sha256-sdBDhiq8lLHUWQ6QPQdNAOulN8mbN/ClA6M6epNoMtM=";

  types-aiobotocore-rds = buildTypesAiobotocorePackage "rds" "2.8.0" "sha256-jPsnB5nI2bgEASmjUGZF+68maAn2xhRzJRiML/DeGqw=";

  types-aiobotocore-rds-data = buildTypesAiobotocorePackage "rds-data" "2.8.0" "sha256-hR0sIaIyBFlbzg/M7CsHMFy0K6xqVSkEA9UL2bM0B9g=";

  types-aiobotocore-redshift = buildTypesAiobotocorePackage "redshift" "2.8.0" "sha256-4t6A4Lf9uRlM8RwU+kLXHzj4mqg6K9N9P6EwqQZaCfA=";

  types-aiobotocore-redshift-data = buildTypesAiobotocorePackage "redshift-data" "2.8.0" "sha256-KsWZO1WJcQmeFjrIgFVWKWv1A3J1QIyyV/eyNd7wVOA=";

  types-aiobotocore-redshift-serverless = buildTypesAiobotocorePackage "redshift-serverless" "2.8.0" "sha256-jOiSQFXLHFTIqRLICkrnO52PY6OjbxC1itz7nvUC+Hw=";

  types-aiobotocore-rekognition = buildTypesAiobotocorePackage "rekognition" "2.8.0" "sha256-4pIfKFKErbYgifG2EzImfI0bq2l18j/S4LMNkFppAEg=";

  types-aiobotocore-resiliencehub = buildTypesAiobotocorePackage "resiliencehub" "2.8.0" "sha256-m2VZ6PUAlwv1J3sTu1b0JjvVCStJUhmmPA0OStUBkQU=";

  types-aiobotocore-resource-explorer-2 = buildTypesAiobotocorePackage "resource-explorer-2" "2.8.0" "sha256-qIOrsQb5b99tKyh4sLxl10M8lPHGfNGFDY0LQO0HSes=";

  types-aiobotocore-resource-groups = buildTypesAiobotocorePackage "resource-groups" "2.8.0" "sha256-XuP4BReFtJeG2RxWkLcSY0sA66qad/XPYfXnkRTu1hY=";

  types-aiobotocore-resourcegroupstaggingapi = buildTypesAiobotocorePackage "resourcegroupstaggingapi" "2.8.0" "sha256-FSySNIUKn3zXXQ22Bs123tdUd638XNaIbr9SDwenuF0=";

  types-aiobotocore-robomaker = buildTypesAiobotocorePackage "robomaker" "2.8.0" "sha256-ZFg/a0f4jd9FRTs3VtjXqLrnaSATnx3RyAvo1yE4OQw=";

  types-aiobotocore-rolesanywhere = buildTypesAiobotocorePackage "rolesanywhere" "2.8.0" "sha256-gDxYlHHVpMi1Tij7WjZ19I7h1ds5n15+Nv10nvQMpRo=";

  types-aiobotocore-route53 = buildTypesAiobotocorePackage "route53" "2.8.0" "sha256-2IFoKB/F8si+6t8NJhTLnkTfmrxUuawvmTPL/xjpisc=";

  types-aiobotocore-route53-recovery-cluster = buildTypesAiobotocorePackage "route53-recovery-cluster" "2.8.0" "sha256-YZMIJRsydm7OXN4U9odFPcpTSolErDg1w/APTfitns8=";

  types-aiobotocore-route53-recovery-control-config = buildTypesAiobotocorePackage "route53-recovery-control-config" "2.8.0" "sha256-Z9MO4KbvY8KmNI/P5xfHxZXg4UDlPOPNAQmDUaqB6x8=";

  types-aiobotocore-route53-recovery-readiness = buildTypesAiobotocorePackage "route53-recovery-readiness" "2.8.0" "sha256-HT4WZXmPxB3RusYeyZez6edNiMx/D1R1z2ltdnzadVA=";

  types-aiobotocore-route53domains = buildTypesAiobotocorePackage "route53domains" "2.8.0" "sha256-rgAqcvNylkiF1QqMcQ5mERQzH2BRwOog2GukJRy4hDE=";

  types-aiobotocore-route53resolver = buildTypesAiobotocorePackage "route53resolver" "2.8.0" "sha256-nBdBFNLndUyWTAHI9IoOOCqfNnfKDYtIpF/8+j25WE8=";

  types-aiobotocore-rum = buildTypesAiobotocorePackage "rum" "2.8.0" "sha256-RpL6fTjQ0Nem0WzzMZU17RlYyWhTBEEPSsZsnvr3vGY=";

  types-aiobotocore-s3 = buildTypesAiobotocorePackage "s3" "2.8.0" "sha256-bXxNPmXNmTp/J+QmKAluRM0D39C0ypDgmBPZsWQzmgc=";

  types-aiobotocore-s3control = buildTypesAiobotocorePackage "s3control" "2.8.0" "sha256-y/RVSdtFwjt1WIYJi+CqI0Up2v+T8h0+SwG34jgnyjs=";

  types-aiobotocore-s3outposts = buildTypesAiobotocorePackage "s3outposts" "2.8.0" "sha256-HbRv5VHTRKJgZKqZVROwC6zqyuQgP+JLFZPYoq2Bc6o=";

  types-aiobotocore-sagemaker = buildTypesAiobotocorePackage "sagemaker" "2.8.0" "sha256-5zeuzcfNiyMzvc9vR04WJtEZMkIELrPsKnstYPwZfKg=";

  types-aiobotocore-sagemaker-a2i-runtime = buildTypesAiobotocorePackage "sagemaker-a2i-runtime" "2.8.0" "sha256-c5a8uIoR0GNfH2Q35S6BdrXEWq3tKQA1yhV3TUYM1K8=";

  types-aiobotocore-sagemaker-edge = buildTypesAiobotocorePackage "sagemaker-edge" "2.8.0" "sha256-AIh2DZXWuMFjX8opA08MXWLN5K5CVWyjLo8yYmsJRaE=";

  types-aiobotocore-sagemaker-featurestore-runtime = buildTypesAiobotocorePackage "sagemaker-featurestore-runtime" "2.8.0" "sha256-MzAYMFEpZZtLS59bBSOLwLkwpU8H9kOseEPcxj6Eonw=";

  types-aiobotocore-sagemaker-geospatial = buildTypesAiobotocorePackage "sagemaker-geospatial" "2.8.0" "sha256-nesFHgQyGtzmUfdOItfMlbWvBFHU+v7VNz4foE7SX2o=";

  types-aiobotocore-sagemaker-metrics = buildTypesAiobotocorePackage "sagemaker-metrics" "2.8.0" "sha256-hJYVJObV7tT9jV3h5oykjI0cRI9VlnEa4tLyWc9Htek=";

  types-aiobotocore-sagemaker-runtime = buildTypesAiobotocorePackage "sagemaker-runtime" "2.8.0" "sha256-FjrthSpe9zRvmg+nS2E+ZoXKt7kdR13F1mwMzya7Dsw=";

  types-aiobotocore-savingsplans = buildTypesAiobotocorePackage "savingsplans" "2.8.0" "sha256-OWIx0v5n89afasRAkrPxfFWZvUm0k2ItHIOyQcVsX3I=";

  types-aiobotocore-scheduler = buildTypesAiobotocorePackage "scheduler" "2.8.0" "sha256-uMtA82NpANN591t6RyunEDtguv5CVPMtF+XoFc8DTao=";

  types-aiobotocore-schemas = buildTypesAiobotocorePackage "schemas" "2.8.0" "sha256-pONqi41QAjLUsiX/iI1SFc8BEMCKSdXvhZsE/P/GnSw=";

  types-aiobotocore-sdb = buildTypesAiobotocorePackage "sdb" "2.8.0" "sha256-iy9m+iioGBhUSTTL48TCEmlxSPac31Nyh5OOShQ6SN8=";

  types-aiobotocore-secretsmanager = buildTypesAiobotocorePackage "secretsmanager" "2.8.0" "sha256-tHlwGQTuoY6WVMlwunucy/IoPQ4d8fbj8iJN/Rwd3sE=";

  types-aiobotocore-securityhub = buildTypesAiobotocorePackage "securityhub" "2.8.0" "sha256-ghW0dULuXuj3ZBpFNe30W8Wr8e/19rXlHbE/7B7thKU=";

  types-aiobotocore-securitylake = buildTypesAiobotocorePackage "securitylake" "2.8.0" "sha256-vrtlZBYIMx+G66E1B/setODz2Ebw8oEZAr7MwgeWYpk=";

  types-aiobotocore-serverlessrepo = buildTypesAiobotocorePackage "serverlessrepo" "2.8.0" "sha256-i55VJJ1lB4TDF+aMpBBlAicP015G5C6HfbmkRneKRj0=";

  types-aiobotocore-service-quotas = buildTypesAiobotocorePackage "service-quotas" "2.8.0" "sha256-wBn9opW2nBTJ8AlSkQb3Vudn5M0MoujBJJQv3wpzd/U=";

  types-aiobotocore-servicecatalog = buildTypesAiobotocorePackage "servicecatalog" "2.8.0" "sha256-FJbynDHyf1Rzz68l6m2Nx3Z/gbz1xKvyti+Y+TKToCs=";

  types-aiobotocore-servicecatalog-appregistry = buildTypesAiobotocorePackage "servicecatalog-appregistry" "2.8.0" "sha256-fOJzjEmaDu61tPKSk3+AqRB5YML/t0E4Pph/vYBCbqI=";

  types-aiobotocore-servicediscovery = buildTypesAiobotocorePackage "servicediscovery" "2.8.0" "sha256-NG8amAmPBM9zxeBjFOjHjJWv0n02kmkQ3t2p2a8ueDs=";

  types-aiobotocore-ses = buildTypesAiobotocorePackage "ses" "2.8.0" "sha256-2lXqLkIdTHQnt81eQ8gMY3rTqEdrAIr0sLdbSpDqsBk=";

  types-aiobotocore-sesv2 = buildTypesAiobotocorePackage "sesv2" "2.8.0" "sha256-ZA0GffcyOufLp7eL2nXJ/I9J2d4nPMSO6oGnINu1r3c=";

  types-aiobotocore-shield = buildTypesAiobotocorePackage "shield" "2.8.0" "sha256-t7TLwIPwyvE8kdehytLbDm833wv5/VHkq2fMXS8GTYY=";

  types-aiobotocore-signer = buildTypesAiobotocorePackage "signer" "2.8.0" "sha256-ZgHWKACxm1LFxS9W+lEktaQI5ZEupWxLre+aET497kg=";

  types-aiobotocore-simspaceweaver = buildTypesAiobotocorePackage "simspaceweaver" "2.8.0" "sha256-RmZn+M23w5LeEN94GL++5G3KqPxHdK7yS45HrexO254=";

  types-aiobotocore-sms = buildTypesAiobotocorePackage "sms" "2.8.0" "sha256-0suDa/XD5mmYIa+xLLS1ctmJNvUSkXKb1JM9ypUImgo=";

  types-aiobotocore-sms-voice = buildTypesAiobotocorePackage "sms-voice" "2.8.0" "sha256-aYf/FX2jFSiJCbOD4DgNV2wtPUaQIFFVJMwYa43+SH0=";

  types-aiobotocore-snow-device-management = buildTypesAiobotocorePackage "snow-device-management" "2.8.0" "sha256-43zwyMqYz/tIeFSD8sFrnUhy0GgfIV57eP5TebUfa7g=";

  types-aiobotocore-snowball = buildTypesAiobotocorePackage "snowball" "2.8.0" "sha256-+wGCOB7OMw8ocImLAKTrbLAMk7Svy9IrV43d88++iNM=";

  types-aiobotocore-sns = buildTypesAiobotocorePackage "sns" "2.8.0" "sha256-nHXh6Pn01PrBP1pfPIYEFDJHVBcMyCHrbugzFitFNlI=";

  types-aiobotocore-sqs = buildTypesAiobotocorePackage "sqs" "2.8.0" "sha256-/HXBFrcsKbFP23+sbYIhDAMKCTvC8RcY0Yd7LjDw+0Y=";

  types-aiobotocore-ssm = buildTypesAiobotocorePackage "ssm" "2.8.0" "sha256-8WqU8zVfd4ks3v2taDDb9a/SIhbbNQ9nvN5RtwUiFtQ=";

  types-aiobotocore-ssm-contacts = buildTypesAiobotocorePackage "ssm-contacts" "2.8.0" "sha256-geKe1U86jmBHNmMoxtzk+s+la44cJTmdxNt+eIRNPrk=";

  types-aiobotocore-ssm-incidents = buildTypesAiobotocorePackage "ssm-incidents" "2.8.0" "sha256-pI0awh2ykT+1piQXVEVWtM95hzo9T2i3afBudGBKKDI=";

  types-aiobotocore-ssm-sap = buildTypesAiobotocorePackage "ssm-sap" "2.8.0" "sha256-eTQq35NWsj0XFmX60i9f1zMftUQy16zAMHjL4rMF/+0=";

  types-aiobotocore-sso = buildTypesAiobotocorePackage "sso" "2.8.0" "sha256-crnFBiGAgZ69htxJ1p8sTX5NGnbc3qEsdFHL4LiLsig=";

  types-aiobotocore-sso-admin = buildTypesAiobotocorePackage "sso-admin" "2.8.0" "sha256-XmBDoWgfEkVT2u8Ms1ag3JtUCpencUoX0EfB7/VsSmM=";

  types-aiobotocore-sso-oidc = buildTypesAiobotocorePackage "sso-oidc" "2.8.0" "sha256-U5Ll1edEe3eNbLqGWd7O9uNef0b32JXwEfu+M8Kg2uI=";

  types-aiobotocore-stepfunctions = buildTypesAiobotocorePackage "stepfunctions" "2.8.0" "sha256-A9if+EGhVRR9PpXb7Ai1u2XcWS/HlHNgFPI+oy4Xf3Q=";

  types-aiobotocore-storagegateway = buildTypesAiobotocorePackage "storagegateway" "2.8.0" "sha256-xZYge7wyTJA6TDkiMqIgESv/xEb3e/4WFxTMD9hedG0=";

  types-aiobotocore-sts = buildTypesAiobotocorePackage "sts" "2.8.0" "sha256-TWDc+OQ1ZQH4hs2yyKGzJWxImRsTiSHsNT64eBSg9+E=";

  types-aiobotocore-support = buildTypesAiobotocorePackage "support" "2.8.0" "sha256-6rTtWFb0W7A6kK9vn+OmLW8eaMmeYcUgC3u71HBEk78=";

  types-aiobotocore-support-app = buildTypesAiobotocorePackage "support-app" "2.8.0" "sha256-CA6oHF9JMvOx+hayuBoQ6y/FlZEoZTtfmej6sW25UY0=";

  types-aiobotocore-swf = buildTypesAiobotocorePackage "swf" "2.8.0" "sha256-M21DsVjEP2foyd8DMJjnlalM7vwAPLorSBU7P3Bt1vg=";

  types-aiobotocore-synthetics = buildTypesAiobotocorePackage "synthetics" "2.8.0" "sha256-bJH/5ltKeojYXOuiaDSWE5LUv2dqE78CROzeRXOqV84=";

  types-aiobotocore-textract = buildTypesAiobotocorePackage "textract" "2.8.0" "sha256-AudV7RCbIPYvy1IgYrSC1I8PPT9lLCVR28RCtJ1Fd8o=";

  types-aiobotocore-timestream-query = buildTypesAiobotocorePackage "timestream-query" "2.8.0" "sha256-QMZKTjNdfz2Oxjdtnc3tICe823R4Vp1ETJfupXMX2lE=";

  types-aiobotocore-timestream-write = buildTypesAiobotocorePackage "timestream-write" "2.8.0" "sha256-QiNnwX+NCknSAlsrMDTBFBaDoD1iXcJBA19VEVFh8CY=";

  types-aiobotocore-tnb = buildTypesAiobotocorePackage "tnb" "2.8.0" "sha256-9uQX3ssLhPM2ErTvyXpC+346+BCkyB19DRhGVyLeDRw=";

  types-aiobotocore-transcribe = buildTypesAiobotocorePackage "transcribe" "2.8.0" "sha256-LuLHmUEyOCimS4xUhE6zizTfn4MQBj27T2obwnsSK/w=";

  types-aiobotocore-transfer = buildTypesAiobotocorePackage "transfer" "2.8.0" "sha256-vq0nimWY3nho1u2lgl8f0CDMFc5aFYzI/TmE3XAqXXg=";

  types-aiobotocore-translate = buildTypesAiobotocorePackage "translate" "2.8.0" "sha256-ir/tmp8wb5+dZ8ldydMAtm4kWJ5/g4NeZVG0Aly2lOk=";

  types-aiobotocore-verifiedpermissions = buildTypesAiobotocorePackage "verifiedpermissions" "2.8.0" "sha256-825T4k/GtzClkQRFf0JtiHz7BkrSuN2ZLTm/Gg8VIzU=";

  types-aiobotocore-voice-id = buildTypesAiobotocorePackage "voice-id" "2.8.0" "sha256-TIBXAir9uhnBw+XUC+uF0PxX2YqSy++0lzmrZA7dNrQ=";

  types-aiobotocore-vpc-lattice = buildTypesAiobotocorePackage "vpc-lattice" "2.8.0" "sha256-MQZdWFYWOgFQwcoPa7XjV+W6CU0B4TGsYlWPAX3wP7o=";

  types-aiobotocore-waf = buildTypesAiobotocorePackage "waf" "2.8.0" "sha256-ZV/Niqalk80HEjLmhSKMMrckRqbgMfa5SR/ld9HOkGs=";

  types-aiobotocore-waf-regional = buildTypesAiobotocorePackage "waf-regional" "2.8.0" "sha256-rHA7mkFCAs8vlxD37aqpmDQTEt9glaCkDNdNZF+Zkao=";

  types-aiobotocore-wafv2 = buildTypesAiobotocorePackage "wafv2" "2.8.0" "sha256-yJ5OgSx/7OhwA5IrzTwFJqJjOWsy4Z5muJNqOckrvqo=";

  types-aiobotocore-wellarchitected = buildTypesAiobotocorePackage "wellarchitected" "2.8.0" "sha256-pdBZddHeWEJF0Va3ylwqNlCixcNCucqhJS4E6MOlstk=";

  types-aiobotocore-wisdom = buildTypesAiobotocorePackage "wisdom" "2.8.0" "sha256-8pAUOTT8QHEyT0EvQCT9B0YL9k7hYIblPKCbWqaL7rI=";

  types-aiobotocore-workdocs = buildTypesAiobotocorePackage "workdocs" "2.8.0" "sha256-WJU83Td6vRgmKyfhYlRU4miHJHb2h7tg/12IJClHGrY=";

  types-aiobotocore-worklink = buildTypesAiobotocorePackage "worklink" "2.8.0" "sha256-AfXk/UyL5feDePCN4+pgSH3eCfpyeEimn8T/+JsD/tw=";

  types-aiobotocore-workmail = buildTypesAiobotocorePackage "workmail" "2.8.0" "sha256-DAigC9aIAEXYcIPCNihBI89LRZ5WAdWdlTPwzMmAwqE=";

  types-aiobotocore-workmailmessageflow = buildTypesAiobotocorePackage "workmailmessageflow" "2.8.0" "sha256-esJylPZPnj2zGsoKikbckg4/3cXXCdLe/x8PiLtDveQ=";

  types-aiobotocore-workspaces = buildTypesAiobotocorePackage "workspaces" "2.8.0" "sha256-c023BH5DuggzCOWjPAmG1luA+d2PKJzU/wKMyy5wUp4=";

  types-aiobotocore-workspaces-web = buildTypesAiobotocorePackage "workspaces-web" "2.8.0" "sha256-7ZbI/QXl4N8OFFviPSsWWx0rX4Lpr9zIV/dQTSLLnMQ=";

  types-aiobotocore-xray = buildTypesAiobotocorePackage "xray" "2.8.0" "sha256-dlrCaCiX4Sc/jClstj/pZLyeTNpLJEpGJHVIkpWQsQA=";
}
