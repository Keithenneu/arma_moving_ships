class CfgFunctions
{
    class ships
    {
        class ShipMovement
        {
            file = "functions\ShipMovement"; // not needed for addon
            class GoInCircles {};
            class BackAndForth {};
            class FreeDriving {};
            class UpdatePosition {};
            class HandleShips {};
        };
        class PlayerHandling
        {
            file = "functions\PlayerHandling"; // not needed for addon
            class MoveOnShip {};
            class MoveOnShipVehicle {};
            class OnRespawn {};
        };
        class Setup
        {
            file = "functions\Setup"; // not needed for addon
            class AddDestroyerWeapons {};
            class PreInit {preInit = 1};
            class PostInit {postInit = 1};
            class InitShip {};
        };
    };
};
