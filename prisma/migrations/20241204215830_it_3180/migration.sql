BEGIN TRY

BEGIN TRAN;

-- CreateTable
CREATE TABLE [dbo].[Account] (
    [id] NVARCHAR(1000) NOT NULL,
    [userId] NVARCHAR(1000) NOT NULL,
    [type] NVARCHAR(1000) NOT NULL,
    [provider] NVARCHAR(1000) NOT NULL,
    [providerAccountId] NVARCHAR(1000) NOT NULL,
    [refresh_token] NVARCHAR(1000),
    [access_token] NVARCHAR(1000),
    [expires_at] INT,
    [token_type] NVARCHAR(1000),
    [scope] NVARCHAR(1000),
    [id_token] NVARCHAR(1000),
    [session_state] NVARCHAR(1000),
    CONSTRAINT [Account_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [Account_provider_providerAccountId_key] UNIQUE NONCLUSTERED ([provider],[providerAccountId])
);

-- CreateTable
CREATE TABLE [dbo].[Session] (
    [id] NVARCHAR(1000) NOT NULL,
    [sessionToken] NVARCHAR(1000) NOT NULL,
    [userId] NVARCHAR(1000) NOT NULL,
    [expires] DATETIME2 NOT NULL,
    CONSTRAINT [Session_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [Session_sessionToken_key] UNIQUE NONCLUSTERED ([sessionToken])
);

-- CreateTable
CREATE TABLE [dbo].[User] (
    [id] NVARCHAR(1000) NOT NULL,
    [name] NVARCHAR(1000),
    [email] NVARCHAR(1000) NOT NULL,
    [password] NVARCHAR(1000),
    [emailVerified] DATETIME2,
    [image] NVARCHAR(1000),
    [create_at] DATETIME2 NOT NULL CONSTRAINT [User_create_at_df] DEFAULT CURRENT_TIMESTAMP,
    [update_at] DATETIME2 NOT NULL CONSTRAINT [User_update_at_df] DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT [User_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [User_email_key] UNIQUE NONCLUSTERED ([email])
);

-- CreateTable
CREATE TABLE [dbo].[VerificationToken] (
    [identifier] NVARCHAR(1000) NOT NULL,
    [token] NVARCHAR(1000) NOT NULL,
    [expires] DATETIME2 NOT NULL,
    CONSTRAINT [VerificationToken_token_key] UNIQUE NONCLUSTERED ([token]),
    CONSTRAINT [VerificationToken_identifier_token_key] UNIQUE NONCLUSTERED ([identifier],[token])
);

-- CreateTable
CREATE TABLE [dbo].[Resident] (
    [id] NVARCHAR(1000) NOT NULL,
    [nationalId] NVARCHAR(1000) NOT NULL,
    [phoneNumber] NVARCHAR(1000) NOT NULL,
    [name] NVARCHAR(1000) NOT NULL,
    [gender] NVARCHAR(1000) NOT NULL,
    [vehicle] NVARCHAR(1000) NOT NULL,
    [create_at] DATETIME2 NOT NULL CONSTRAINT [Resident_create_at_df] DEFAULT CURRENT_TIMESTAMP,
    [update_at] DATETIME2 NOT NULL CONSTRAINT [Resident_update_at_df] DEFAULT CURRENT_TIMESTAMP,
    [addressId] NVARCHAR(1000) NOT NULL,
    CONSTRAINT [Resident_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [Resident_nationalId_key] UNIQUE NONCLUSTERED ([nationalId]),
    CONSTRAINT [Resident_addressId_key] UNIQUE NONCLUSTERED ([addressId])
);

-- CreateTable
CREATE TABLE [dbo].[Address] (
    [id] NVARCHAR(1000) NOT NULL,
    [apartmentNo] INT NOT NULL,
    [permanentAddress] NVARCHAR(1000) NOT NULL,
    [currentAddress] NVARCHAR(1000) NOT NULL,
    [isStaying] BIT NOT NULL,
    CONSTRAINT [Address_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[DateRange] (
    [id] NVARCHAR(1000) NOT NULL,
    [start_date] DATETIME2 NOT NULL CONSTRAINT [DateRange_start_date_df] DEFAULT CURRENT_TIMESTAMP,
    [end_date] DATETIME2 NOT NULL,
    [type] NVARCHAR(1000) NOT NULL,
    [addressId] NVARCHAR(1000) NOT NULL,
    CONSTRAINT [DateRange_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- CreateTable
CREATE TABLE [dbo].[Apartment] (
    [id] INT NOT NULL IDENTITY(1,1),
    [apartmentNo] INT NOT NULL,
    [size] INT NOT NULL,
    CONSTRAINT [Apartment_pkey] PRIMARY KEY CLUSTERED ([id]),
    CONSTRAINT [Apartment_apartmentNo_key] UNIQUE NONCLUSTERED ([apartmentNo])
);

-- CreateTable
CREATE TABLE [dbo].[Fee] (
    [id] NVARCHAR(1000) NOT NULL,
    [apartmentSizeFee] INT NOT NULL,
    [internetFee] INT NOT NULL,
    [electricityFee] INT NOT NULL,
    [waterFee] INT NOT NULL,
    [contributionFee] INT,
    [vehicleFee] INT NOT NULL,
    [notes] NVARCHAR(1000),
    [amount] FLOAT(53) NOT NULL,
    [dueDate] DATETIME2 NOT NULL,
    [isPaid] BIT NOT NULL CONSTRAINT [Fee_isPaid_df] DEFAULT 0,
    [apartmentNo] INT NOT NULL,
    [create_at] DATETIME2 NOT NULL CONSTRAINT [Fee_create_at_df] DEFAULT CURRENT_TIMESTAMP,
    [update_at] DATETIME2 NOT NULL CONSTRAINT [Fee_update_at_df] DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT [Fee_pkey] PRIMARY KEY CLUSTERED ([id])
);

-- AddForeignKey
ALTER TABLE [dbo].[Account] ADD CONSTRAINT [Account_userId_fkey] FOREIGN KEY ([userId]) REFERENCES [dbo].[User]([id]) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[Session] ADD CONSTRAINT [Session_userId_fkey] FOREIGN KEY ([userId]) REFERENCES [dbo].[User]([id]) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[Resident] ADD CONSTRAINT [Resident_addressId_fkey] FOREIGN KEY ([addressId]) REFERENCES [dbo].[Address]([id]) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[Address] ADD CONSTRAINT [Address_apartmentNo_fkey] FOREIGN KEY ([apartmentNo]) REFERENCES [dbo].[Apartment]([apartmentNo]) ON DELETE NO ACTION ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[DateRange] ADD CONSTRAINT [DateRange_addressId_fkey] FOREIGN KEY ([addressId]) REFERENCES [dbo].[Address]([id]) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE [dbo].[Fee] ADD CONSTRAINT [Fee_apartmentNo_fkey] FOREIGN KEY ([apartmentNo]) REFERENCES [dbo].[Apartment]([apartmentNo]) ON DELETE CASCADE ON UPDATE CASCADE;

COMMIT TRAN;

END TRY
BEGIN CATCH

IF @@TRANCOUNT > 0
BEGIN
    ROLLBACK TRAN;
END;
THROW

END CATCH
