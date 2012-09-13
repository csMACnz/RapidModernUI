using System.Diagnostics;
using System.Windows.Threading;
using Caliburn.Micro;
using $rootnamespace$.ViewModels;
using $rootnamespace$.Views;

namespace $rootnamespace$
{
    public class AppBootstrapper : Bootstrapper<ShellViewModel>
    {
        private SimpleContainer _container;

        protected override void Configure()
        {
            base.Configure();

            _container = new SimpleContainer();

            _container.Singleton<IWindowManager, WindowManager>();
            _container.Singleton<IEventAggregator, EventAggregator>();

            //CM doesn't include code for instantiating concrete types automatically yet(1.3.1).
            _container.PerRequest<ShellViewModel>();
            _container.PerRequest<ShellView>();
            _container.PerRequest<Page1View>();
            _container.PerRequest<Page1ViewModel>();
            _container.PerRequest<Page2View>();
            _container.PerRequest<Page2ViewModel>();
        }

        protected override void OnUnhandledException(object sender, DispatcherUnhandledExceptionEventArgs e)
        {
            BreakOnDebug(sender, e);
            base.OnUnhandledException(sender, e);
        }

        [Conditional("DEBUG")]
        private void BreakOnDebug(object sender, DispatcherUnhandledExceptionEventArgs args)
        {
            if (Debugger.IsAttached)
            {
                Debugger.Break();
            }
        }

        #region IOC
        
        protected override object GetInstance(System.Type service, string key)
        {
            return _container.GetInstance(service, key);
        }

        protected override System.Collections.Generic.IEnumerable<object> GetAllInstances(System.Type service)
        {
            return _container.GetAllInstances(service);
        }

        protected override void BuildUp(object instance)
        {
            _container.BuildUp(instance);
        }
        
        #endregion IOC
    }
}
