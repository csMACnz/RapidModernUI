using System;
using System.Windows.Navigation;

namespace RapidModernUI.Sample
{
    public interface INavigationService
    {
        /// <summary>
        ///   The <see cref="Uri" /> source.
        /// </summary>
        Uri Source { get; set; }

        /// <summary>
        ///   Indicates whether the navigator can navigate back.
        /// </summary>
        bool CanGoBack { get; }

        /// <summary>
        ///   Indicates whether the navigator can navigate forward.
        /// </summary>
        bool CanGoForward { get; }

        /// <summary>
        ///   The current <see cref="Uri" /> source.
        /// </summary>
        Uri CurrentSource { get; }

        /// <summary>
        ///   The current content.
        /// </summary>
        object CurrentContent { get; }

        /// <summary>
        ///   Stops the loading process.
        /// </summary>
        void StopLoading();

        /// <summary>
        ///   Navigates back.
        /// </summary>
        void GoBack();

        /// <summary>
        ///   Navigates forward.
        /// </summary>
        void GoForward();

        /// <summary>
        /// Navigates this instance.
        /// </summary>
        /// <param name="source">The source.</param>
        bool Navigate(Uri source);

        /// <summary>
        ///   Removes the most recent entry from the back stack.
        /// </summary>
        /// <returns> The entry that was removed. </returns>
        JournalEntry RemoveBackEntry();

        /// <summary>
        ///   Raised after navigation.
        /// </summary>
        event NavigatedEventHandler Navigated;

        /// <summary>
        ///   Raised prior to navigation.
        /// </summary>
        event NavigatingCancelEventHandler Navigating;

        /// <summary>
        ///   Raised when navigation fails.
        /// </summary>
        event NavigationFailedEventHandler NavigationFailed;

        /// <summary>
        ///   Raised when navigation is stopped.
        /// </summary>
        event NavigationStoppedEventHandler NavigationStopped;

        /// <summary>
        ///   Raised when a fragment navigation occurs.
        /// </summary>
        event FragmentNavigationEventHandler FragmentNavigation;
    }
}