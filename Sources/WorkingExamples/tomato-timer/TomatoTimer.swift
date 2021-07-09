import SwiftUI
import Foundation
import Combine

struct TomatoTimer: View {

  @StateObject private var timer = TimerEngine(60)

  private var status: TimerEngine.Status {
    timer.status
  }

  var body: some View {
    VStack {
      Text("🍅").font(.system(size: 200))
      .opacity(0.75)
      .overlay(
        Text(timer.timeRemaining.formatted)
        .font(.system(size: 36, weight: .bold, design: .monospaced))
        .blendMode(.overlay)
      )
      buttons
    }
    .accentColor(.red)
  }

  var buttons: some View {
    VStack {

      // Start / Pause / Resume
      Button {
        withAnimation {
          if status == .active {
            timer.pause()
          } else {
            timer.start()
          }
        }
      } label: {
        Label(status == .ready ? "Start" : status == .active ? "Pause" : "Resume" , systemImage: status == .active ? "pause.circle.fill" : "play.circle.fill")
      }

      if status == .ready {
        HStack {
          Button {
            withAnimation {
              timer.set(30)
            }
          } label: {
            Label("30''", systemImage: "timer")
          }

          Button {
            withAnimation {
              timer.set(90)
            }
          } label: {
            Label("1.5'", systemImage: "timer")
          }

          Button {
            withAnimation {
              timer.set(180)
            }
          } label: {
            Label("3'", systemImage: "timer")
          }
        }
        .font(.subheadline)
        .padding()
        .transition(.opacity)
      } else {
        Button {
          withAnimation {
            timer.reset()
          }
        } label: {
          Label("Reset", systemImage: "arrowshape.turn.up.backward.circle.fill")
        }
        .padding()
        .opacity(status == .paused || status == .expired ? 1 : 0)
        .transition(.opacity)
      }
    }
    .font(.headline)
  }
}

fileprivate /* actor */ class TimerEngine: ObservableObject {

  enum Status {
    case ready, active, paused, expired
  }

  @Published var initialTime: TimeInterval
  @Published var status = Status.ready
  @Published var timeRemaining: TimeInterval

  private let timer = Timer.publish(every: 0.1, on: .main, in: .common)

  private var cancellable: Cancellable?
  private var lastTimestamp = TimeInterval?.none

  init(_ initialTime: TimeInterval) {
    self.initialTime = initialTime
    self.timeRemaining = initialTime
  }

  func set(_ seconds: TimeInterval) {
    initialTime = seconds
    timeRemaining = seconds
  }

  func start() {
    cancellable = timer.autoconnect().sink(receiveValue: processTick)
    status = .active
  }

  func reset() {
    guard status != .active else {
      return
    }
    timeRemaining = initialTime
    status = .ready
  }

  func pause() {
    cancellable?.cancel()
    //timer = Self.defaultTimer
    lastTimestamp = .none

    status = .paused
  }

  private func processTick(_ time: Date) {
    let newTimeInterval = time.timeIntervalSinceReferenceDate

    guard let previousLastTime = lastTimestamp else {
      lastTimestamp = newTimeInterval
      return
    }

    let increment = newTimeInterval - previousLastTime
    let newTimeRemaining = timeRemaining - increment
    let asjustedTimeRemaining = newTimeRemaining > 0 ? newTimeRemaining : 0

    timeRemaining = asjustedTimeRemaining

    if asjustedTimeRemaining == 0 {
      cancellable?.cancel()
      lastTimestamp = .none

      status = .expired
    } else {
      lastTimestamp = newTimeInterval
    }
  }
}

fileprivate extension TimeInterval {

  static let secondsInHour = 3600.0
  static let secondsInMinute = 60.0
  static let minutesInHour = 60.0

  var formatted: String {
    let hours = Int(self / Self.secondsInHour)
    let minutes = Int(self / Self.secondsInMinute) - hours * Int(Self.minutesInHour)
    let seconds = Int(self) - hours * Int(Self.secondsInHour) - minutes * Int(Self.secondsInMinute)
    let secondsAsDouble = self - Double(hours) * Self.secondsInHour - Double(minutes) * Self.secondsInMinute

    if hours > 0 {
      return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    } else if minutes > 0 || self == 0 {
      return String(format: "%02d:%02d", minutes, seconds)
    } else {
      return String(format: "%02d:%04.1f", minutes, secondsAsDouble)
    }
  }
}

struct TomatoTimer_Previews: PreviewProvider {
  static var previews: some View {
    TomatoTimer()
  }
}
