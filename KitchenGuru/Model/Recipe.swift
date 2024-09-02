import Foundation

// MARK: - Recipe
struct Recipe: Codable {
    let title, recipeHistory: String
    let instructions: [String]
}

// MARK: Recipe convenience initializers and mutators

extension Recipe {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(Recipe.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        title: String? = nil,
        recipeHistory: String? = nil,
        instructions: [String]? = nil
    ) -> Recipe {
        return Recipe(
            title: title ?? self.title,
            recipeHistory: recipeHistory ?? self.recipeHistory,
            instructions: instructions ?? self.instructions
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}


//MARK: Mock
let beefWellingtonRecipe = Recipe(
    title: "Beef Wellington",
    recipeHistory: """
Beef Wellington is a classic dish of English cuisine that dates back to the 19th century. Named after the Duke of Wellington, this dish typically features a fillet steak coated with pâté and duxelles, which is then wrapped in puff pastry and baked. It has become a popular and elegant dish often served at celebratory dinners and special occasions.
""",
    instructions: [
        "Preheat the oven to 400°F (200°C).",
        "Season the beef fillet with salt and pepper, and sear it in a hot pan until browned on all sides. Set aside to cool.",
        "Finely chop the mushrooms and sauté them in the same pan with some butter, garlic, and shallots until they become a thick paste (duxelles).",
        "Spread a layer of pâté over the cooled beef fillet.",
        "Spread the mushroom duxelles over the pâté-covered beef fillet.",
        "Roll out the puff pastry on a floured surface and place the beef in the center.",
        "Wrap the pastry around the beef, sealing the edges and trimming any excess pastry.",
        "Place the wrapped beef on a baking sheet, seam side down, and brush the pastry with beaten egg.",
        "Bake in the preheated oven for about 25-30 minutes, or until the pastry is golden brown and the beef is cooked to your desired level of doneness.",
        "Let the Beef Wellington rest for 10 minutes before slicing and serving."
    ]
)
