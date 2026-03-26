dotnet publish ./frontend/FleetPortal/ -c Release -r linux-x64 --self-contained -o ./frontend/deployment
dotnet publish ./backend/FleetAPI/ -c Release -r linux-x64 --self-contained -o ./backend/deployment
cd ./frontend/deployment/
zip -r ../deployment.zip .

cd ../../backend/deployment/
zip -r ../deployment.zip .

pwd
cd ../../
cp -f ./backend/deployment.zip ../packer/backend
cp -f ./frontend/deployment.zip ../packer/frontend
pwd
rm -r ./frontend/deployment/
rm -r ./backend/deployment/
