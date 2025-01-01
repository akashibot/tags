use mlua::prelude::*;

#[tokio::main]
async fn main() {
    let parser_code = tokio::fs::read_to_string("src/parser.lua").await.unwrap();
    let lua = Lua::new();

    let start = std::time::Instant::now();

    let input = lua.create_string("{set(name):Alice} Hello {get:name}! {if(name):Exists:Does not exist}").unwrap();
    let output_local = lua.create_string("").unwrap();
    lua.globals().set("input", input).unwrap();
    lua.globals().set("output", output_local).unwrap();

    lua.load(&parser_code).exec().unwrap();
    println!("from rust: {}", lua.globals().get::<String>("output").unwrap());
    println!("Elapsed time: {:?}", start.elapsed());
}
