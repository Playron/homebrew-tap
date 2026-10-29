# Cask for sbx, the Azure Service Bus explorer in github.com/Playron/homelab (apps/sbx).
# The version and sha256 lines are rewritten by the sbx-release workflow in that repo on
# every sbx-v* tag; do not edit them by hand unless that workflow failed.
cask "sbx" do
  version "0.2.0"
  sha256 "9e50713e807bd39fc137777b6f2e5af252ce3adbbfbc2304366e8901715a1ab8"

  url "https://github.com/Playron/homelab/releases/download/sbx-v#{version}/sbx-#{version}-osx-arm64.tar.gz"
  name "sbx"
  desc "Azure Service Bus explorer"
  homepage "https://github.com/Playron/homelab/tree/main/apps/sbx"

  # The homelab repo tags other apps too, so match the sbx-v prefix rather than "latest".
  livecheck do
    url "https://github.com/Playron/homelab.git"
    regex(/^sbx-v(\d+(?:\.\d+)+)$/i)
    strategy :git
  end

  depends_on arch: :arm64
  depends_on macos: ">= :monterey"

  app "Sbx.app"

  # The bundle is ad hoc signed, not notarised, so Gatekeeper would refuse it with the quarantine
  # flag Homebrew puts on downloads. Clearing it here does what the README otherwise asks the
  # user to do by hand. Goes away if the app ever gets Developer ID signing and notarisation.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Sbx.app"],
                   sudo: false
  end

  # Profiles, log and name cache. Connection strings live in the Keychain (service "sbx") and
  # are left alone; remove them from Keychain Access if you want them gone too.
  zap trash: "~/.local/share/sbx"
end
