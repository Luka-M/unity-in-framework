
UNITY_PROJECT="$(pwd)/Unity"

/Applications/Unity/Unity.app/Contents/MacOS/Unity -quit -batchmode -projectPath $UNITY_PROJECT -executeMethod Build.BuildPlayerIOS

rm -rf Framework/SpaceShooter/Unity/Classes
rm -rf Framework/SpaceShooter/Unity/Data
rm -rf Framework/SpaceShooter/Unity/Libraries

cp -R "$UNITY_PROJECT/PlayerBuild/Classes" Framework/SpaceShooter/Unity/Classes
cp -R "$UNITY_PROJECT/PlayerBuild/Data" Framework/SpaceShooter/Unity/Data
cp -R "$UNITY_PROJECT/PlayerBuild/Libraries" Framework/SpaceShooter/Unity/Libraries
