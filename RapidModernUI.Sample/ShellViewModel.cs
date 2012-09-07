using System;
using Caliburn.Micro;

namespace RapidModernUI.Sample
{
    public class ShellViewModel: Screen
    {
        private readonly INavigationService _navigationService;

        public ShellViewModel(INavigationService navigationService)
        {
            _navigationService = navigationService;
        }

        protected override void OnViewLoaded(object view)
        {
            base.OnViewLoaded(view);
            //_navigationService.Navigate(new Uri("/Views/Page1View.xaml"));
        }
    }
}
