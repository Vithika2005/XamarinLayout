namespace LayoutsDemo;

public partial class MainPage : ContentPage
{
    public MainPage()
    {
        InitializeComponent();
    }

    private async void OnViewProfileClicked(object? sender, EventArgs e)
    {
        await DisplayAlert("Profile", "Opening the full profile of Alex Morgan...", "OK");
    }
}
