using Server.Accounting;
using System;

namespace Server.Misc
{
    public class AccountPrompt
    {
        public static void Initialize()
        {
            if (Accounts.Count == 0 && !Core.Service)
            {
                _ = new Account("OWNER_USERNAME", "OWNER_PASSWORD")
                    {
                        AccessLevel = AccessLevel.Owner
                    };

                Console.WriteLine("***Initial Admin Account Created***");
                Console.WriteLine("User: OWNER_USERNAME");
                Console.WriteLine("Password: OWNER_PASSWORD");
            }
        }
    }
}
