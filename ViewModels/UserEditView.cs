using System;
using Microsoft.EntityFrameworkCore;
using QSmartBackend.DAL;
using QSmartBackend.BLL;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace QSmartBackend.ViewModels
{
    public class UserEditView
    {
        public int UserID { get; set; }
        //All strings should have a default of string.Empty
        public string FullName { get; set; } = string.Empty;
        public string Email { get; set; } = string.Empty;
        public DateTime? CreatedAt { get; set; }
    }
}