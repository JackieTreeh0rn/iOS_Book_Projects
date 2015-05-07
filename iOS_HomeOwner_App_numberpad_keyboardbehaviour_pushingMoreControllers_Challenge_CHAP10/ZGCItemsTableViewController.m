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
#import "ZGCDetailViewController.h" // using this tableviewcontroller as the object to push more viewcontrolers the navigation controller's stack

@interface ZGCItemsTableViewController ()

/* Using navigation bar now
@property (nonatomic, strong) IBOutlet UIView *headerView; //using strong instead of weak as this will be a top level object in the XIB. Weak is used for objects that are owned directly/indirectly by the top level objects.
*/

@end


@implementation ZGCItemsTableViewController

/* Changing designated initializer to "init" (default is initWithStyle:)
 then will override superclass' designated initializer to call this one */
- (instancetype)init {
    // Call superclass designated initializer (rule)
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        // Assigning navigationitem properties for this controller during its init.
        // navitem gets passed to navigation bar of navigation controller (a title, right button, left button)
        UINavigationItem *navItem = self.navigationItem;
        
        /* navItem title */
        navItem.title = @"HomeOwner";
        
        /* navItem right Button */ // <-- uses instances of UIBarButtonItem
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                             target:self
                                                                             action:@selector(addNewItem:)];
        navItem.rightBarButtonItem = bbi;
        
        /* navItem left Button */
        // this editButtonitem UIViewController property is a UIBarButtonItem
        // already preconfigured with a target:action: pair that sends the
        // message setEditing:animated: to its UIViewController (this replaces our
        // previous EDIT button implemtation used previously in the tableview's headerview.
        navItem.leftBarButtonItem = self.editButtonItem; // <-- this property
        
        // for (int i = 0; i < 5; i++) {
        // [[ZGCItemStore sharedStore] createItem]; // initiates store, create 5 items
        }
    
    return self;
}

/* Overriding superclass designated initializer to call mine */
- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [self init]; // all instances will now use plainviewstyle
}

/* Overriding viewWillAppear: on this controller to 
 reload the tableview and see changes made in detailViewController */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated]; // you always call superclass implementation on this method
    
    // refresh tableview contents
    [self.tableView reloadData];
    

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* This is required to tell the tableview which kind of cell
     it should instantiate if there are no cells in the reuse pool
     when cellForView protocol method is called */
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
/* //Using navigation bar now
    // Tell the table view about the headerview
    UIView *header = self.headerView; // loaded from the NIB
    [self.tableView setTableHeaderView:header]; // link to tableview
*/
    
    
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
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    
    // Insert this new row into the table
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    
    /* the tableview is going to run through the datasource methods
     immidiately after the above insertRowsAtIndexPaths is called to get
     the actual cell content, details, etc */
    
    
}

/* // Using Navigation Bar's edit  property now //
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
*/


/* // Using Navigation Bar
#pragma mark - custom headerView getter method - to load header XIB
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
*/


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
// #warning Potentially incomplete method implementation.
    // Return the number of sections.
    
    return 1;
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
    // Unlike deleting a row, this method requires no additional confirmation, tableview moves the row on its own authority and reports the move to its datasource with this message:
    [[ZGCItemStore sharedStore] moveItemAtIndex:fromIndexPath.row toIndex:toIndexPath.row];
}


# pragma mark - delegate methods

//// BRONZE CHALLENGE - RENAME DELETE BUTTON ///
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return @"Remove";
}

// this is sent to the delegate (self) when a row is tapped - we going to use this to push detailViewController onto the stack
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // instantiate the detailViewController instance to add to the nav stack
    ZGCDetailViewController *detailViewController = [[ZGCDetailViewController alloc] init];
    
    // Instantiate an instance of ZGCItem to the selected item/row per the indexPath
    NSArray *items = [[ZGCItemStore sharedStore] allItems];
    ZGCItem *selectedItem = items[indexPath.row];
    
    // Pass a pointer to the item to the detailViewController
    detailViewController.item = selectedItem;
    
    // push it on top of the nav controller stack
    // any object part of a nav controller has the navigationController property you can message - this controller is the rootviewcontroller of the nav contrllr.
    [self.navigationController pushViewController:detailViewController animated:YES];
    
    
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
