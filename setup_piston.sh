git init piston-setup
cd piston-setup
git remote add origin https://github.com/YOUR_USERNAME/piston-setup.git
cp /path/to/setup_piston.sh .
git add setup_piston.sh
git commit -m "Add piston auto-setup script"
git push -u origin master
