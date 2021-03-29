//
//  ZGCItemsTableViewController.m
//  iOS_HomeOwner_App
//
//  Created by EvilKernel on 4/4/15.
//  Copyright (c) 2015 Zerogravity. All rights reserved.
//

#import "ZGCItemsTableViewController.h"
#import "ZGCItemStore.h"
#import "ZGCItem.h"

@interface ZGCItemsTableViewController ()


@property (nonatomic, strong) IBOutlet UIView *headerView; //using strong instead of weak as this will be a top level object in the XIB. Weak is used for objects that are owned directly/indirectly by the top level objects.

@end

@implementation ZGCItemsTableViewController

/* Changing designated initializer to "init" (default is initWithStyle:)
 then will override superclass' designated initializer to call this one */
- (instancetype)init {
    // Call superclass designated initializer (rule)
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
   //     for (int i = 0; i < 5; i++) {
   //       [[ZGCItemStore sharedStore] createItem]; // initiates store, create 5 items
   //     }
    }
    return self;
}

/* Overriding superclass designated initializer to call mine */
- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [self init]; // all instances will now use plainviewstyle
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* This is required to tell the tableview which kind of cell
     it should instantiate if there are no cells in the reuse pool
     when cellForView protocol method is called */
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    // Tell the table view about the headerview
    UIView *header = self.headerView; // loaded from the NIB
    [self.tableView setTableHeaderView:header]; // link to tableview
    
    
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Header Methods

- (IBAction)addNewItem:(id)sender {
    // Make a new indexpath for the section 0, last row
    // NSInteger lastRow = [self.tableView numberOfRowsInSection:0];
    
    // Create a new ZGCItem and add it to the store
    ZGCItem *newItem = [[ZGCItemStore sharedStore] createItem];
    
    // Figure out where that item is in the array
    NSInteger lastRow = [[[ZGCItemStore sharedStore] allItems] indexOfObject:newItem];
    
    // Define an index path with that value
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    
    // Insert this new row into the table
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    
    /* the tableview is going to run through the datasource methods
     immidiately after the above insertRowsAtIndexPaths is called to get
     the actual cell content, details, etc */
    
    
}

- (IBAction)toggleEditingMode:(id)sender {
    // If you are currently on editing mode...
    if (self.isEditing) {
        // Change text of button to inform user of state
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        // Turn off editing mode
        [self setEditing:NO animated:YES];
    } else {
        // Change text of button to inform user of state
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        // Enter editing mode
        
        [self setEditing:YES animated:YES];
    }
    
}

#pragma mark - headerView getter method - loads header XIB
- (UIView *)headerView {
    // If you have not loaded the headerView yet...
    if (!_headerView) {
        // Load HeaderView.xib - an instance of nsbundle is automatocally created by your app
        // when it launches. we are sending it a message 'mainbundle' and loading the
        // NIB.  no need to specify suffix
        // owner:self ensures file owner's placeholder (the controller) is the owner
        [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil];
    }
    return _headerView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    
    return 1;
}

/// SILVER CHALLENGE Part 3 - prevent the "no more items" row from being edited/removed/moved
// with this datasource protocol method

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BOOL isEditable = YES;
    NSUInteger count = [[[ZGCItemStore sharedStore] allItems] count];
    
    if (indexPath.row == count - 1) {
        isEditable = NO;
    }
    
    return isEditable;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // #warning Incomplete method implementation.
    // Return the number of rows in the section. equals n. of items in array
    return [[[ZGCItemStore sharedStore] allItems] count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    /*
     // Create an instance of UITableViewCell, with default apperance
     UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
     */
    
    // Using conventional method to create UITableViewCell object via resuable indent.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    // Set the text on the cell with the descripton of the item
    // that is at the nth index of items (n = row this cell will appear on)
    NSArray *items = [[ZGCItemStore sharedStore] allItems];
    ZGCItem *item = items[indexPath.row];
    cell.textLabel.text = [item description];
   
    
    return cell;

    }

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // If the tableview is asking to comit a delete command...
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Lets get the item in the datastore
        NSArray *items = [[ZGCItemStore sharedStore] allItems];
        ZGCItem *item = [items objectAtIndex:indexPath.row];
        
        // Remove item from the datastore array
        [[ZGCItemStore sharedStore] removeItem:item];
        
        // ...Also remove the row from the table view with an animation
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        // [self.tableView reloadData]; // <-- this method works too to refresh the table after a change but, with no animation
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/* When the tableview checks with its datasource (self) and finds this method
 implemented, it will add the re-ordering controls to the table when on editing mode
  */
    // Unlike deleting a row, this method requires no additional confirmation, tableview moves the row on its own authority and reports the move to its datasource with this message:
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
    NSLog(@"%ld", (long)fromIndexPath.row);
    
    [[ZGCItemStore sharedStore] moveItemAtIndex:fromIndexPath.row toIndex:toIndexPath.row];
    
    
}



# pragma mark - delegate method

//// BRONZE CHALLENGE - RENAME DELETE BUTTON to 'REMOVE'///
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"Remove";
}


/// GOLD CHALLENGE - really prevent reordering  - preventing other rows from getting
// dragged underneath last 'No More items' row - Using this delegate method.
- (NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath {
    
    NSArray *items = [[ZGCItemStore sharedStore] allItems];
    
    // Define max row index (-1 since it's 0 based index)
    NSInteger maxRow = items.count - 1;
    
    // If proposed destination row overrides our last row
    // return an indexpath = to the sourceindexpath to prevent moving
    // else, return the desired/destination indexpath
    if (proposedDestinationIndexPath.row == maxRow) {
        NSLog(@"Destionation Row: %ld - not allosed", proposedDestinationIndexPath.row);
        return sourceIndexPath;
    
    }
    return proposedDestinationIndexPath;
}


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
