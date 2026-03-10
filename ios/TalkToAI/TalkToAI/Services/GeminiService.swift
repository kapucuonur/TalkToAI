import Foundation

class GeminiService {
    let apiKey = "YOUR_GEMINI_API_KEY" // Usually passed from a secure config
    let endpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent"
    
    func processSpeech(text: String, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "\(endpoint)?key=\(apiKey)") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let prompt = "You are a professional Garmin AI triathlon coach. Briefly respond to this athlete: \(text)"
        let body: [String: Any] = [
            "contents": [[
                "parts": [["text": prompt]]
            ]]
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else {
                completion(nil)
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let candidates = json["candidates"] as? [[String: Any]],
               let content = candidates.first?["content"] as? [String: Any],
               let parts = content["parts"] as? [[String: Any]],
               let responseText = parts.first?["text"] as? String {
                completion(responseText)
            } else {
                completion(nil)
            }
        }.resume()
    }
}
