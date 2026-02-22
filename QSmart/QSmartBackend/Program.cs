using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;
using QSmartBackend.BLL;
using QSmartBackend.Data;
using QSmartBackend.Models;


var builder = WebApplication.CreateBuilder(args);

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowBlazorFrontend",
        policy =>
        {
            policy.WithOrigins("http://localhost:5084")
                  .AllowAnyHeader()
                  .AllowAnyMethod()
                  .AllowCredentials();
        });
});

// Add services to the container
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(options =>
{
    options.SwaggerDoc("v1", new OpenApiInfo
    {
        Title = "QSmart API",
        Version = "v1",
    });
    options.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        In = ParameterLocation.Header,
        Description = "Please enter a token",
        Name = "Authorization",
        Type = SecuritySchemeType.Http,
        BearerFormat = "JWT",
        Scheme = "Bearer",
    });

    options.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference
                {
                    Type = ReferenceType.SecurityScheme,
                    Id = "Bearer"
                }
            },
            new string[] { }
        }
    });
});
// Database connection
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
var qsmartConnection = builder.Configuration.GetConnectionString("QSmartConnection");
if (!string.IsNullOrEmpty(connectionString))
{
    // Register AppDbContext for Identity
    builder.Services.AddDbContext<AppDbContext>(options =>
        options.UseSqlServer(connectionString));

    // Register QSmartDBContext for your existing services
    builder.Services.AddDbContext<QSmartDBContext>(options =>
        options.UseSqlServer(qsmartConnection));
}

builder.Services.AddAuthentication();
builder.Services.AddAuthorization();
builder.Services.AddIdentityApiEndpoints<AppUser>()
    .AddEntityFrameworkStores<AppDbContext>();

// Add scoped services
builder.Services.AddScoped<SessionService>();
builder.Services.AddScoped<ReadingService>();

var app = builder.Build();

// Apply pending migrations automatically
using (var scope = app.Services.CreateScope())
{
    var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();
    db.Database.Migrate();

    var qsmartDb = scope.ServiceProvider.GetRequiredService<QSmartDBContext>();
    qsmartDb.Database.Migrate();
}

app.MapIdentityApi<AppUser>();

// Configure the HTTP request pipeline
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI(c =>
    {
        c.SwaggerEndpoint("/swagger/v1/swagger.json", "QSmart API");
        c.RoutePrefix = "swagger";
        c.DisplayRequestDuration();
    });
}

app.UseCors("AllowBlazorFrontend");
// app.UseHttpsRedirection();
app.UseRouting();
app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

app.Run();