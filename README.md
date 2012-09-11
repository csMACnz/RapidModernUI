RapidModernUI
=============

Templates and Packages to rapidly bootstrap Caliburn.Micro + IOC(undetermined container) + MahApps.Metro applications in WPF.

This will likely result in a separate navigation project but for now this will be a part of the solution. An extension of this may be to remove the dependancy on MahApps.Metro for a caliburn-specific rapid new project creation.

Intended Nuget Package Features
-----------------------------------

* include caliburn.micro package
* include caliburn.micro container package (or bootstrap with another container)
* include mahapps.metro package
* include a bootstrapper pre wired up for above packages
* include a metrowindow shell view/view model pair of files
* include mainpage view and viewmodel contained in metrowindow shell
* include navigation for single page application (break this out into a navigation package if complex enough, make it stand alone or caliburn specific)
* script to modify the app.xaml class with Caliburn.Micro required components
* script the removal of the default window.xaml file if applicable (ie, is still file new project default code)


Completed Features
---------------------
* Built mock sample of a project this could result in.