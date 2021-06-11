struct SuperBlock {
	unsigned	InodeSum,
			BlockSum,
			ReservedBlockSum,
			FreeBlockSum,
			FreeInodeSum,
			SuperBlockNum,
			BlockSize,
			FragmentSize,
			BlockSumOfGroup,
			PieceSumOfGroup,
			InodeSumOfGroup,
			LastMountTime,
			LastWriteTime;
	unsigned short	InstalledTimes,
		      	AllowesInstallTimes,
		      	Ext2Flag,
		      	FileSystemStatus,
		      	ErrorCode,
		      	Version;
	unsigned	LastCheckTime,
			CheckTimeInterval,
			OperatingSystemID;
	unsigned short	ReservedUserID,
			ReservedGroupID;
};

struct GroupDescription {
	unsigned	BitmapAddr,
			InodeAddr,
			InodeTableAddr;
	unsigned short	FreeBlockSum,
			FreeInodeSum,
			DirctorySum;
};

struct Inode {
	unsigned short	Auth,
			UID;
	unsigned	LowSize,
			LastReadTime,
			CreateTime,
			LastWriteTime,
			DeleteTime;
	unsigned short	GID,
			PointerSum,
			SectionSum,
			Flag,
			SystemFlag,
			FstBlck[12],
			NxtBlck,
			ThdBlck,
			FthBlck,
			Code,
			ExtendFlag1,
			ExtendFlag2,
			PieceBlockAddr,
			OSFlag;
};

struct Entry {
	unsigned	Inode;
	unsigned short	Size;
	unsigned char	Low,
			Type;
	unsigned char	Name[0];
};


