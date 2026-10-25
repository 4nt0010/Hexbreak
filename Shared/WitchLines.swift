import Foundation

/// Le battute della strega. Aggiungine quante vuoi.
enum WitchLines {
    static let start = [
        "Al lavoro! Io intanto mescolo.",
        "Il calderone è acceso. Concentrati.",
        "Lavora, mortale. Ti tengo d'occhio.",
        "Pozione in preparazione. Non distrarti."
    ]

    static let timeUp = [
        "Il calderone bolle! Alzati.",
        "Basta schermo. Pausa, subito.",
        "I tuoi occhi chiedono pietà. Stacca!",
        "È ora. Sgranchisciti, rospetto."
    ]

    static let snooze = [
        "Altri 10 minuti… ti osservo.",
        "Mmh. Va bene, ma ricordatelo.",
        "Il calderone non aspetta per sempre."
    ]

    static let furious = [
        "Ti trasformo in rospo se non ti alzi!",
        "Terzo rinvio. La mia pazienza è finita.",
        "Ho già la bacchetta in mano. PAUSA."
    ]

    static let rest = [
        "Brava/o. Bevi un sorso d'acqua.",
        "Guarda lontano dallo schermo.",
        "Respira. Io schiaccio un pisolino.",
        "Fai due passi, raccogli ingredienti."
    ]

    static let restOver = [
        "Pausa finita. Torniamo al calderone?",
        "Riposato? Allora al lavoro."
    ]

    static func pick(_ list: [String]) -> String {
        list.randomElement() ?? ""
    }
}
