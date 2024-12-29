use serde_json::{value, Map, Value};

#[derive(Debug)]
enum HOCONValue {
    Null,
    Append(Box<HOCONValue>),
    Bool(bool),
    Number(value::Number),
    String(String),
    List(Vec<HOCONValue>),
    Substitution(String, bool),
    Object(Vec<HOCONInclude>, Vec<(String, HOCONValue)>),
    Literal(String),
}

#[derive(Debug)]
enum HOCONInclude {
    Heuristic(String, bool),
    Url(String, bool),
    File(String, bool),
    ClassPath(String, bool),
}

impl HOCONInclude {
    fn map_fst(&self, f: &dyn Fn(&String) -> String) -> HOCONInclude {
        match self {
            HOCONInclude::Heuristic(s, r) => HOCONInclude::Heuristic(f(s), *r),
            HOCONInclude::Url(s, r) => HOCONInclude::Url(f(s), *r),
            HOCONInclude::File(s, r) => HOCONInclude::File(f(s), *r),
            HOCONInclude::ClassPath(s, r) => HOCONInclude::ClassPath(f(s), *r),
        }
    }
}

fn parse_include(o: &Map<String, Value>) -> HOCONInclude {
    let value = o
        .get("value")
        .expect("Missing field 'value' for include statement")
        .as_str()
        .expect("Field 'value' is not a string in include statement")
        .to_string();
    let required = o
        .get("required")
        .expect("Missing field 'required' for include statement")
        .as_bool()
        .expect("Field 'required'is not a bool in include statement");
    let include_type = match o
        .get("type")
        .expect("Missing field 'type' for include statement")
    {
        Value::Null => None,
        Value::String(s) => Some(s.as_str()),
        t => panic!("Field 'type' is not a string in include statement: {:?}", t),
    };

    // Assert that this was an intentional include
    debug_assert!(o.get("_type").and_then(|t| t.as_str()) == Some("include"));

    match include_type {
        None => HOCONInclude::Heuristic(value, required),
        Some("url") => HOCONInclude::Url(value, required),
        Some("file") => HOCONInclude::File(value, required),
        Some("classpath") => HOCONInclude::ClassPath(value, required),
        _ => panic!(
            "Could not recognize type for include statement: {}",
            include_type.unwrap()
        ),
    }
}

fn parse_special_types(o: &Map<String, Value>) -> Option<HOCONValue> {
    o.get("_type")
        .and_then(|r#type| r#type.as_str())
        .map(|r#type| match r#type {
            "substitution" => {
                let value = o
                    .get("value")
                    .expect("Missing value for substitution")
                    .as_str()
                    .unwrap_or_else(|| panic!("Substitution value is not a string: {:?}", o));
                let required = o
                    .get("required")
                    .unwrap_or(&Value::Bool(false))
                    .as_bool()
                    .unwrap_or_else(|| panic!("Substitution value is not a string: {:?}", o));

                debug_assert!(!value.contains('}'));

                HOCONValue::Substitution(value.to_string(), required)
            }
            "append" => {
                let value = o.get("value").expect("Missing value for append");

                HOCONValue::Append(Box::new(json_to_hocon(value)))
            }
            "unquoted_string" => {
                let value = o
                    .get("value")
                    .expect("Missing value for unquoted_string")
                    .as_str()
                    .unwrap_or_else(|| panic!("Unquoted string value is not a string: {:?}", o));

                HOCONValue::Literal(value.to_string())
            }
            _ => panic!(
                "\
          Attribute set contained special element '_type',\
          but its value is not recognized:\n{}",
                r#type
            ),
        })
}

fn json_to_hocon(v: &Value) -> HOCONValue {
    match v {
        Value::Null => HOCONValue::Null,
        Value::Bool(b) => HOCONValue::Bool(*b),
        Value::Number(n) => HOCONValue::Number(n.clone()),
        Value::String(s) => HOCONValue::String(s.clone()),
        Value::Array(a) => {
            let items = a.iter().map(json_to_hocon).collect::<Vec<HOCONValue>>();
            HOCONValue::List(items)
        }
        Value::Object(o) => {
            if let Some(result) = parse_special_types(o) {
                return result;
            }

            let mut items = o
                .iter()
                .filter(|(key, _)| key.as_str() != "_includes")
                .map(|(key, value)| (key.clone(), json_to_hocon(value)))
                .collect::<Vec<(String, HOCONValue)>>();

            items.sort_by(|(a, _), (b, _)| a.partial_cmp(b).unwrap());

            let includes = o
                .get("_includes")
                .map(|x| {
                    x.as_array()
                        .expect("_includes is not an array")
                        .iter()
                        .map(|x| {
                            x.as_object()
                                .unwrap_or_else(|| panic!("Include is not an object: {}", x))
                        })
                        .map(parse_include)
                        .collect::<Vec<HOCONInclude>>()
                })
                .unwrap_or(vec![]);

            HOCONValue::Object(includes, items)
        }
    }
}

impl ToString for HOCONValue {
    fn to_string(&self) -> String {
        match self {
            HOCONValue::Null => "null".to_string(),
            HOCONValue::Bool(b) => b.to_string(),
            HOCONValue::Number(n) => n.to_string(),
            HOCONValue::String(s) => serde_json::to_string(&Value::String(s.clone())).unwrap(),
            HOCONValue::Substitution(v, required) => {
                format!("${{{}{}}}", if *required { "" } else { "?" }, v)
            }
            HOCONValue::List(l) => {
                let items = l
                    .iter()
                    .map(|item| item.to_string())
                    .collect::<Vec<String>>()
                    .join(",\n")
                    .split('\n')
                    .map(|s| "  ".to_owned() + s)
                    .collect::<Vec<String>>()
                    .join("\n");
                format!("[\n{}\n]", items)
            }
            HOCONValue::Object(i, o) => {
                let includes = i
                    .iter()
                    .map(|x| {
                        x.map_fst(&|s| serde_json::to_string(&Value::String(s.clone())).unwrap())
                    })
                    .map(|x| match x {
                        HOCONInclude::Heuristic(s, r) => (s.to_string(), r),
                        HOCONInclude::Url(s, r) => (format!("url({})", s), r),
                        HOCONInclude::File(s, r) => (format!("file({})", s), r),
                        HOCONInclude::ClassPath(s, r) => (format!("classpath({})", s), r),
                    })
                    .map(|(i, r)| if r { format!("required({})", i) } else { i })
                    .map(|s| format!("include {}", s))
                    .collect::<Vec<String>>()
                    .join("\n");
                let items = o
                    .iter()
                    .map(|(key, value)| {
                        (
                            serde_json::to_string(&Value::String(key.clone())).unwrap(),
                            value,
                        )
                    })
                    .map(|(key, value)| match value {
                        HOCONValue::Append(v) => format!("{} += {}", key, v.to_string()),
                        v => format!("{} = {}", key, v.to_string()),
                    })
                    .collect::<Vec<String>>()
                    .join("\n");

                let content = (if includes.is_empty() {
                    items
                } else {
                    format!("{}{}", includes, items)
                })
                .split('\n')
                .map(|s| format!("  {}", s))
                .collect::<Vec<String>>()
                .join("\n");

                format!("{{\n{}\n}}", content)
            }
            HOCONValue::Append(_) => panic!("Append should not be present at this point"),
            Self::Literal(s) => s.to_string(),
        }
    }
}

fn main() {
    let stdin = std::io::stdin().lock();
    let json = serde_json::Deserializer::from_reader(stdin)
        .into_iter::<Value>()
        .next()
        .expect("Could not read content from stdin")
        .expect("Could not parse JSON from stdin");

    print!("{}\n\n", json_to_hocon(&json).to_string());
}
