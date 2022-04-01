import Foundation
// https://github.com/autozimu/StringMetric.swift/blob/master/Sources/StringMetric.swift
// https://stackoverflow.com/questions/54890196/jaro-winkler-distance-in-objective-c-or-swift
let startTime = NSDate()

extension String {
    public func distanceJaroWinkler( _ target: String) -> Double {
           var stringOne = self
           var stringTwo = target
           if stringOne.count > stringTwo.count {
               stringTwo = self
               stringOne = target
           }

           let stringOneCount = stringOne.count
           let stringTwoCount = stringTwo.count

           if stringOneCount == 0 && stringTwoCount == 0 {
               return 1.0
           }

           let matchingDistance = stringTwoCount / 2
           var matchingCharactersCount: Double = 0
           var transpositionsCount: Double = 0
           var previousPosition = -1

           // Count matching characters and transpositions.
           for (i, stringOneChar) in stringOne.enumerated() {
               for (j, stringTwoChar) in stringTwo.enumerated() {
                   if max(0, i - matchingDistance)..<min(stringTwoCount, i + matchingDistance) ~= j {
                       if stringOneChar == stringTwoChar {
                           matchingCharactersCount += 1
                           if previousPosition != -1 && j < previousPosition {
                               transpositionsCount += 1
                           }
                           previousPosition = j
                           break
                       }
                   }
               }
           }

           if matchingCharactersCount == 0.0 {
               return 0.0
           }

           // Count common prefix (up to a maximum of 4 characters)
           let commonPrefixCount = min(max(Double(self.commonPrefix(with: target).count), 0), 4)

           let jaroSimilarity = (matchingCharactersCount / Double(stringOneCount) + matchingCharactersCount / Double(stringTwoCount) + (matchingCharactersCount - transpositionsCount) / matchingCharactersCount) / 3

           // Default is 0.1, should never exceed 0.25 (otherwise similarity score could exceed 1.0)
           let commonPrefixScalingFactor = 0.1

           return jaroSimilarity + commonPrefixCount * commonPrefixScalingFactor * (1 - jaroSimilarity)
       }

}

print("".distanceJaroWinkler( ""))
print("".distanceJaroWinkler("a"))
print("aaapppp".distanceJaroWinkler( ""))
print("frog".distanceJaroWinkler("fog"))
print("fly".distanceJaroWinkler("ant"))
print("elephant".distanceJaroWinkler("hippo"))
print("hippo".distanceJaroWinkler("elephant"))
print("hippo".distanceJaroWinkler("zzzzzzzz"))
print("hello".distanceJaroWinkler("hallo"))
print("ABC Corporation".distanceJaroWinkler("ABC Corp"))
print("D N H Enterprises Inc".distanceJaroWinkler("D & H Enterprises, Inc."))
print("My Gym Children's Fitness Center".distanceJaroWinkler("My Gym. Childrens Fitness"))
print("PENNSYLVANIA".distanceJaroWinkler("PENNCISYLVNIA"))

let endTime = NSDate()

let interval = endTime.timeIntervalSince(startTime as Date) // 0.0062
print(interval)
