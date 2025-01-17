using Computator.NET.Core.Abstract;
using Computator.NET.Localization.Menu;

namespace Computator.NET.Core.Menu.Commands.HelpCommands
{
    public class AboutCommand : CommandBase
    {
        public AboutCommand(IDialogFactory dialogFactory)
        {
            _dialogFactory = dialogFactory;
            //this.ShortcutKeyString = "Shift+6";
            //this.Icon = Resources.exponentation;
            Text = MenuStrings.aboutToolStripMenuItem1_Text;
            ToolTip = MenuStrings.aboutToolStripMenuItem1_Text;
        }
        
        private IDialogFactory _dialogFactory;

        public override void Execute()
        {
            _dialogFactory.ShowDialog("about");
        }
    }
}