using ProjectAPI.DAL.Models;

namespace ProjectAPI.Services;

public interface ITokenService
{
    string CreateToken(ApplicationUser user);
}