using Xunit;
using System;
using System.IO;
using System.Text;

namespace GildedRoseApp
{
    public class ApprovalTest
    {
        [Fact]
        public void ThirtyDays()
        {
            var lines = File.ReadAllLines("ThirtyDays.txt");

            StringBuilder fakeoutput = new StringBuilder();
            Console.SetOut(new StringWriter(fakeoutput));
            Console.SetIn(new StringReader("a\n"));

            Program.Main(new string[] { });
            String output = fakeoutput.ToString();

            var outputLines = output.Split(new string[] { Environment.NewLine }, StringSplitOptions.None);
            for (var i = 0; i<Math.Min(lines.Length, outputLines.Length); i++) 
            {
                Assert.Equal(lines[i], outputLines[i]);
            }
        }
    }
}
