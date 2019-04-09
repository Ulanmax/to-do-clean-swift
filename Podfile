platform :ios, '11.0'

def rx_swift
    pod 'RxSwift'
end

def rx_cocoa
    pod 'RxCocoa'
end

def queryKit
    pod 'QueryKit', :git => 'https://github.com/Ulanmax/QueryKit.git'
end

def test_pods
    pod 'RxTest'
    pod 'RxBlocking'
    pod 'Nimble'
end


target 'to-do-clean' do

  use_frameworks!

  rx_cocoa
  rx_swift
  queryKit
  target 'to-do-cleanTests' do
    inherit! :search_paths
    test_pods
  end

  target 'to-do-cleanUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

target 'CoreDataPlatform' do

  use_frameworks!
  rx_swift
  queryKit
  target 'CoreDataPlatformTests' do
    inherit! :search_paths
    test_pods
  end

end


target 'Domain' do

  use_frameworks!
  rx_swift

  target 'DomainTests' do
    inherit! :search_paths
    test_pods
  end

end


target 'RealmPlatform' do

  use_frameworks!
  rx_swift
  pod "RxRealm"
  queryKit
  pod 'RealmSwift'

  target 'RealmPlatformTests' do
    inherit! :search_paths
    test_pods
  end

end
