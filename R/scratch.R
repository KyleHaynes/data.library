if(FALSE){
    # jsonlite::read_json("C:\\temp\\metadata_2024-12-01.json")

    devtools::document()
    md = list(dataset = list(name = list("iris dataset"), description = list(
        "longer desc")), variables = list(`1` = list("Sepal.Length",
        "Sepal.Width", "Petal.Length", "Petal.Width", "Species"),
        Sepal.Length = list(short_description = list("the Sepal Length"),
            foobar = list("2024-12-01")), Sepal.Width = list(short_description = list(
            "the Sepal Width"), foobar = list("2024-12-01")), Petal.Length = list(
            short_description = list("the petal Length"), foobar = list(
                "2024-12-01")), Petal.Width = list(short_description = list(
            ""), foobar = list("2024-12-01")), Species = list(short_description = list(
            ""), foobar = list("2024-12-01")), `7` = list(""), `8` = list(
            "")))


    output(iris, metadata = md)

    input()

}
