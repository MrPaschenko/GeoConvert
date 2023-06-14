import Foundation

class Coordinates {
    
    var SK42: [Double] = [0, 0, 0]
    var WGS84: [Double] = [0, 0, 0]
    
    let ro = 206264.8062 // Number of arc seconds in a radian

    // Krassovsky Ellipsoid
    let aP = 6378245 // Major semi-axis
    let alP = 1 / 298.3 // Flattening
    lazy var e2P = 2 * alP - pow(alP, 2) // Eccentricity squared
    // WGS84 Ellipsoid (GRS80, these two ellipsoids are similar in most parameters)
    let aW = 6378137 // Major semi-axis
    let alW = 1 / 298.257223563 // Flattening
    lazy var e2W = 2 * alW - pow(alW, 2) // Eccentricity squared

    // Auxiliary values for ellipsoid transformation
    lazy var a: Double = Double((aP + aW)) / 2.0
    lazy var e2 = (e2P + e2W) / 2
    lazy var da: Double = Double(aW - aP)
    lazy var de2 = e2W - e2P

    // Linear transformation elements in meters
    let dx = 23.92
    let dy = -141.27
    let dz = -80.9

    // Angular transformation elements in seconds
    let wx = 0.0
    let wy = 0.0
    let wz = 0.0

    // Differential scale difference
    let ms = 0.0

    // Function to convert degrees to radians
    private func degreesToRadians(_ degrees: Double) -> Double {
        return degrees * .pi / 180
    }

    // Function to convert radians to degrees
    private func radiansToDegrees(_ radians: Double) -> Double {
        return radians * 180 / .pi
    }

    // Convert WGS84 coordinates to SK42 (Krassovsky) latitude
    private func WGS84_SK42_Lat(Bd: Double, Ld: Double, H: Double) -> Double {
        return Bd - dB(Bd: Bd, Ld: Ld, H: H) / 3600
    }

    // Convert SK42 (Krassovsky) coordinates to WGS84 latitude
    private func SK42_WGS84_Lat(Bd: Double, Ld: Double, H: Double) -> Double {
        return Bd + dB(Bd: Bd, Ld: Ld, H: H) / 3600
    }

    // Convert WGS84 coordinates to SK42 (Krassovsky) longitude
    private func WGS84_SK42_Long(Bd: Double, Ld: Double, H: Double) -> Double {
        return Ld - dL(Bd: Bd, Ld: Ld, H: H) / 3600
    }

    // Convert SK42 (Krassovsky) coordinates to WGS84 longitude
    private func SK42_WGS84_Long(Bd: Double, Ld: Double, H: Double) -> Double {
        return Ld + dL(Bd: Bd, Ld: Ld, H: H) / 3600
    }

    // Function to calculate the latitude difference between WGS84 and SK42 (Krassovsky)
    private func dB(Bd: Double, Ld: Double, H: Double) -> Double {
        let B = degreesToRadians(Bd)
        let L = degreesToRadians(Ld)
        lazy var M = a * (1 - e2) / pow((1 - e2 * pow(sin(B), 2)), 1.5)
        let N = a * pow((1 - e2 * pow(sin(B), 2)), -0.5)
        let term1 = ro / (M + H) * (N / a * e2 * sin(B) * cos(B) * da
            + (pow(N, 2) / pow(a, 2) + 1) * N * sin(B) * cos(B) * de2 / 2
            - (dx * cos(L) + dy * sin(L)) * sin(B) + dz * cos(B))
        let term2 = wx * sin(L) * (1 + e2 * cos(2 * B))
        let term3 = wy * cos(L) * (1 + e2 * cos(2 * B))
        let term4 = ro * ms * e2 * sin(B) * cos(B)
        return term1 - term2 + term3 - term4
    }

    // Function to calculate the longitude difference between WGS84 and SK42 (Krassovsky)
    private func dL(Bd: Double, Ld: Double, H: Double) -> Double {
        let B = degreesToRadians(Bd)
        let L = degreesToRadians(Ld)
        let N = a * pow((1 - e2 * pow(sin(B), 2)), -0.5)
        let term1 = ro / ((N + H) * cos(B)) * (-dx * sin(L) + dy * cos(L))
        let term2 = tan(B) * (1 - e2) * (wx * cos(L) + wy * sin(L))
        let term3 = wz
        return term1 + term2 - term3
    }

    // Function to calculate the WGS84 altitude
    private func WGS84Alt(Bd: Double, Ld: Double, H: Double) -> Double {
        let B = degreesToRadians(Bd)
        let L = degreesToRadians(Ld)
        let N = a * pow((1 - e2 * pow(sin(B), 2)), -0.5)
        
        let term1 = -a / N * da
        let term2 = N * pow(sin(B), 2) * de2 / 2
        let term3 = (dx * cos(L) + dy * sin(L)) * cos(B)
        let term4 = dz * sin(B)
        let term5 = N * e2 * sin(B) * cos(B) * (wx / ro * sin(L) - wy / ro * cos(L))
        let term6 = (pow(a, 2) / N + H) * ms
        
        let dH = term1 + term2 + term3 + term4 - term5 + term6
        return H + dH
    }

    // Convert SK42 coordinates to WGS84
    func SK42_WGS84() {
        WGS84 = []
        
        let newLatitude = SK42_WGS84_Lat(Bd: SK42[0], Ld: SK42[1], H: SK42[2])
        let newLongtitude = SK42_WGS84_Long(Bd: SK42[0], Ld: SK42[1], H: SK42[2])
        
        WGS84 = [newLatitude, newLongtitude, 0]
    }

    // Convert WGS84 coordinates to SK42
    func WGS84_SK42() {
        SK42 = []
        
        let newLatitude = WGS84_SK42_Lat(Bd: WGS84[0], Ld: WGS84[1], H: WGS84[2])
        let newLongtitude = WGS84_SK42_Long(Bd: WGS84[0], Ld: WGS84[1], H: WGS84[2])
        
        SK42 = [newLatitude, newLongtitude, 0]
    }
}
