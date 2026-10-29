use serde_json::Value;
use std::mem::discriminant;

#[derive(Debug)]
enum LibConfigIntNumber {
    Oct(i64),
    Hex(i64),
    Int(i64),
}

#[derive(Debug)]
enum LibConfigValue {
    Bool(bool),
    Int(LibConfigIntNumber),
    Float(f64),
    String(String),
    Array(Vec<LibConfigValue>),
    List(Vec<LibConfigValue>),
    Group(Vec<String>, Vec<(String, LibConfigValue)>),
}

fn validate_setting_name(key: &str) -> bool {
    let first_char = key.chars().next().expect("Empty setting name");
    (first_char.is_alphabetic() || first_char == '*')
        && key[1..]
            .chars()
            .all(|c| c.is_alphanumeric() || c == '_' || c == '*' || c == '-')
}

const SPECIAL_TYPES: [&str; 5] = ["octal", "hex", "float", "list", "array"];

fn object_is_special_type(o: &serde_json::Map<String, Value>) -> Option<&str> {
    o.get("_type").and_then(|x| x.as_str()).and_then(|x| {
        if SPECIAL_TYPES.contains(&x) {
            Some(x)
        } else {
            None
        }
    })
}

fn vec_is_array(v: &Vec<LibConfigValue>) -> bool {
    if v.is_empty() {
        return true;
    }

    let first_item = v.first().unwrap();

    if match first_item {
        LibConfigValue::Array(_) => true,
        LibConfigValue::List(_) => true,
        LibConfigValue::Group(_, _) => true,
        _ => false,
    } {
        return false;
    };

    v[1..]
        .iter()
        .all(|item| discriminant(first_item) == discriminant(item))
}

fn json_to_libconfig(v: &Value) -> LibConfigValue {
    match v {
        Value::Null => panic!("Null value not allowed in libconfig"),
        Value::Bool(b) => LibConfigValue::Bool(b.clone()),
        Value::Number(n) => {
            if n.is_i64() {
                LibConfigValue::Int(LibConfigIntNumber::Int(n.as_i64().unwrap()))
            } else if n.is_f64() {
                LibConfigValue::Float(n.as_f64().unwrap())
            } else {
                panic!("{} is not i64 or f64, cannot be represented as number in libconfig", n);
            }
        }
        Value::String(s) => LibConfigValue::String(s.to_string()),
        Value::Array(a) => {
            let items = a
                .iter()
                .map(|item| json_to_libconfig(item))
                .collect::<Vec<LibConfigValue>>();
            LibConfigValue::List(items)
        }
        Value::Object(o) => {
            if let Some(_type) = object_is_special_type(o) {
                let value = o
                    .get("value")
                    .expect(format!("Missing value for special type: {}", &_type).as_str());

                return match _type {
                    "octal" => {
                        let str_value = value
                            .as_str()
                            .expect(
                                format!("Value is not a string for special type: {}", &_type)
                                    .as_str(),
                            )
                            .to_owned();

                        LibConfigValue::Int(LibConfigIntNumber::Oct(
                            i64::from_str_radix(&str_value, 8)
                                .expect(format!("Invalid octal value: {}", value).as_str()),
                        ))
                    }
                    "hex" => {
                        let str_value = value
                            .as_str()
                            .expect(
                                format!("Value is not a string for special type: {}", &_type)
                                    .as_str(),
                            )
                            .to_owned();

                        LibConfigValue::Int(LibConfigIntNumber::Hex(
                            i64::from_str_radix(&str_value[2..], 16)
                                .expect(format!("Invalid hex value: {}", value).as_str()),
                        ))
                    }
                    "float" => {
                        let str_value = value
                            .as_str()
                            .expect(
                                format!("Value is not a string for special type: {}", &_type)
                                    .as_str(),
                            )
                            .to_owned();

                        LibConfigValue::Float(
                            str_value
                                .parse::<f64>()
                                .expect(format!("Invalid float value: {}", value).as_str()),
                        )
                    }
                    "list" => {
                        let items = value
                            .as_array()
                            .expect(
                                format!("Value is not an array for special type: {}", &_type)
                                    .as_str(),
                            )
                            .to_owned()
                            .iter()
                            .map(|item| json_to_libconfig(item))
                            .collect::<Vec<LibConfigValue>>();

                        LibConfigValue::List(items)
                    }
                    "array" => {
                        let items = value
                            .as_array()
                            .expect(
                                format!("Value is not an array for special type: {}", &_type)
                                    .as_str(),
                            )
                            .to_owned()
                            .iter()
                            .map(|item| json_to_libconfig(item))
                            .collect::<Vec<LibConfigValue>>();

                        if !vec_is_array(&items) {
                            panic!(
                                "This can not be an array because of its contents: {:#?}",
                                items
                            );
                        }

                        LibConfigValue::Array(items)
                    }
                    _ => panic!("Invalid type: {}", _type),
                };
            }

            let mut items = o
                .iter()
                .filter(|(key, _)| key.as_str() != "_includes")
                .map(|(key, value)| (key.clone(), json_to_libconfig(value)))
                .collect::<Vec<(String, LibConfigValue)>>();
            items.sort_by(|(a,_),(b,_)| a.partial_cmp(b).unwrap());

            let includes = o
                .get("_includes")
                .map(|x| {
                    x.as_array()
                        .expect("_includes is not an array")
                        .iter()
                        .map(|x| {
                            x.as_str()
                                .expect("_includes item is not a string")
                                .to_owned()
                        })
                        .collect::<Vec<String>>()
                })
                .unwrap_or(vec![]);

            for (key,_) in items.iter() {
                if !validate_setting_name(key) {
                    panic!("Invalid setting name: {}", key);
                }
            }
            LibConfigValue::Group(includes, items)
        }
    }
}

impl ToString for LibConfigValue {
    fn to_string(&self) -> String {
        match self {
            LibConfigValue::Bool(b) => b.to_string(),
            LibConfigValue::Int(i) => match i {
                LibConfigIntNumber::Oct(n) => format!("0{:o}", n),
                LibConfigIntNumber::Hex(n) => format!("0x{:x}", n),
                LibConfigIntNumber::Int(n) => n.to_string(),
            },
            LibConfigValue::Float(n) => format!("{:?}", n),
            LibConfigValue::String(s) => {
                format!("\"{}\"", s.replace("\\", "\\\\").replace("\"", "\\\""))
            }
            LibConfigValue::Array(a) => {
                let items = a
                    .iter()
                    .map(|item| item.to_string())
                    .collect::<Vec<String>>()
                    .join(", ");
                format!("[{}]", items)
            }
            LibConfigValue::List(a) => {
                let items = a
                    .iter()
                    .map(|item| item.to_string())
                    .collect::<Vec<String>>()
                    .join(", ");
                format!("({})", items)
            }
            LibConfigValue::Group(i, o) => {
                let includes = i
                    .iter()
                    .map(|x| x.replace("\\", "\\\\").replace("\"", "\\\""))
                    .map(|x| format!("@include \"{}\"", x))
                    .collect::<Vec<String>>()
                    .join("\n");
                let items = o
                    .iter()
                    .map(|(key, value)| format!("{}={};", key, value.to_string()))
                    .collect::<Vec<String>>()
                    .join("");
                if includes.is_empty() {
                    format!("{{{}}}", items)
                } else {
                    format!("{{\n{}\n{}}}", includes, items)
                }
            }
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

    for (key, value) in json
        .as_object()
        .expect("Top level of JSON file is not an object")
    {
        print!("{}={};", key, json_to_libconfig(value).to_string());
    }
    print!("\n\n");
}
